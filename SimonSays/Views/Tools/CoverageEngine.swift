import Foundation

/// Port of the nesting engine behind simonsays.coach's PPF Coverage Calculator.
enum CoverageEngine {
    static let maxSurfaces = 20

    struct Surface: Identifiable, Hashable {
        let id: Int
        var name: String
        var length: Double
        var width: Double
        var qty: Int
        var netArea: Double { length * width * Double(max(qty, 0)) }
    }

    struct Piece: Identifiable {
        let id: Int
        let surfaceID: Int
        let name: String
        let colorIndex: Int
        /// Cut dimensions (with trim added)
        let l: Double
        let w: Double
        let origL: Double
        let origW: Double
    }

    final class Zone {
        let id: Int
        let length: Double
        var pieces: [(piece: Piece, rotated: Bool, pw: Double)]
        var usedW: Double
        init(id: Int, length: Double, first: Piece, rotated: Bool, pw: Double) {
            self.id = id
            self.length = length
            self.pieces = [(first, rotated, pw)]
            self.usedW = pw
        }
        func strips(rollWidth rw: Double) -> Int { max(1, Int(ceil(usedW / rw - 1e-9))) }
        func film(rollWidth rw: Double) -> Double { round4(length * Double(strips(rollWidth: rw))) }
    }

    struct Placement {
        let zone: Zone
        let rotated: Bool
        let isNew: Bool
    }

    struct PieceRow: Identifiable {
        let piece: Piece
        let baselineStrips: Int
        let baselineFilm: Double
        let zoneNumber: Int
        let rotated: Bool
        let nestedAlongside: String?
        var id: Int { piece.id }
    }

    struct BarSegment: Identifiable {
        let id: Int
        let name: String
        let film: Double
        let colorIndex: Int
    }

    struct Result {
        let pieces: [Piece]
        let netArea: Double
        let cutArea: Double
        let baselineFilm: Double
        let nestedFilm: Double
        let baselineCost: Double
        let nestedCost: Double
        let savingFilm: Double
        let savingCost: Double
        let savingPct: Double
        let baselineSegments: [BarSegment]
        let nestedSegments: [BarSegment]
        let rows: [PieceRow]
    }

    static func round4(_ v: Double) -> Double { (v * 10_000).rounded() / 10_000 }
    static func round2(_ v: Double) -> Double { (v * 100).rounded() / 100 }

    private static func validOrientations(_ p: Piece, rollWidth rw: Double) -> [(pl: Double, pw: Double, rot: Bool)] {
        var out: [(Double, Double, Bool)] = []
        var seen = Set<String>()
        for (pl, pw, rot) in [(p.l, p.w, false), (p.w, p.l, true)] where pw <= rw + 1e-6 {
            let key = String(format: "%.4f,%.4f", pl, pw)
            if seen.insert(key).inserted { out.append((pl, pw, rot)) }
        }
        return out.map { (pl: $0.0, pw: $0.1, rot: $0.2) }
    }

    private static func nest(_ pieces: [Piece], rollWidth rw: Double) -> (zones: [Zone], placements: [Int: Placement], totalFilm: Double) {
        let sorted = pieces.sorted { $0.l * $0.w > $1.l * $1.w }
        var zones: [Zone] = []
        var placements: [Int: Placement] = [:]
        var zid = 0

        for piece in sorted {
            let opts = validOrientations(piece, rollWidth: rw)
            var best: (waste: Double, zone: Zone, rot: Bool)? = nil

            for zone in zones {
                for o in opts {
                    var used = zone.usedW.truncatingRemainder(dividingBy: rw)
                    if used < 1e-9 && zone.usedW > 1e-9 { used = rw }
                    let remW = rw - used
                    if o.pl <= zone.length + 1e-6 && o.pw <= remW + 1e-6 {
                        let waste = remW - o.pw
                        if best == nil || waste < best!.waste { best = (waste, zone, o.rot) }
                    }
                }
            }

            if let best {
                let pw = best.rot ? piece.l : piece.w
                best.zone.pieces.append((piece, best.rot, pw))
                best.zone.usedW = ((best.zone.usedW + pw) * 1_000_000).rounded() / 1_000_000
                placements[piece.id] = Placement(zone: best.zone, rotated: best.rot, isNew: false)
            } else if opts.isEmpty {
                let zone = Zone(id: zid, length: piece.l, first: piece, rotated: false, pw: piece.w)
                zid += 1
                zones.append(zone)
                placements[piece.id] = Placement(zone: zone, rotated: false, isNew: true)
            } else {
                let o = opts.max { $0.pl < $1.pl }!
                let pw = o.rot ? piece.l : piece.w
                let zone = Zone(id: zid, length: o.pl, first: piece, rotated: o.rot, pw: pw)
                zid += 1
                zones.append(zone)
                placements[piece.id] = Placement(zone: zone, rotated: o.rot, isNew: true)
            }
        }

        let total = round4(zones.reduce(0) { $0 + $1.film(rollWidth: rw) })
        return (zones, placements, total)
    }

    static func compute(surfaces: [Surface], rollWidth: Double, trimCm: Double, marginPct: Double, costPerM2: Double) -> Result {
        let rw = rollWidth > 0 ? rollWidth : 1.52
        let trimM = (trimCm * 2) / 100
        let marginFactor = 1 + marginPct / 100

        var pieces: [Piece] = []
        for (i, s) in surfaces.enumerated() {
            for q in 0..<max(s.qty, 0) {
                pieces.append(Piece(id: s.id * 100 + q, surfaceID: s.id, name: s.name, colorIndex: i,
                                    l: round4(s.length + trimM), w: round4(s.width + trimM),
                                    origL: s.length, origW: s.width))
            }
        }

        var baseFilmRaw = 0.0
        var baseMap: [Int: (strips: Int, film: Double)] = [:]
        for p in pieces {
            let strips = max(1, Int(ceil(p.w / rw - 1e-9)))
            let film = round4(p.l * Double(strips))
            baseFilmRaw = round4(baseFilmRaw + film)
            baseMap[p.id] = (strips, film)
        }

        let nested = nest(pieces, rollWidth: rw)

        let baseFilm = round4(baseFilmRaw * marginFactor)
        let nestedFilm = round4(nested.totalFilm * marginFactor)
        let net = round4(pieces.reduce(0) { $0 + $1.origL * $1.origW })
        let cut = round4(pieces.reduce(0) { $0 + $1.l * $1.w })
        let cBase = round2(baseFilm * rw * costPerM2)
        let cNest = round2(nestedFilm * rw * costPerM2)
        let savFilm = round4(baseFilm - nestedFilm)
        let savCost = round2(cBase - cNest)
        let savPct = baseFilm > 0 ? ((savFilm / baseFilm * 1000).rounded() / 10) : 0

        let baseSegments = pieces.map { p in
            BarSegment(id: p.id, name: p.name, film: baseMap[p.id]?.film ?? 0, colorIndex: p.colorIndex)
        }
        let nestSegments: [BarSegment] = nested.zones.map { z in
            let names: [String] = z.pieces.map { entry in
                let full = entry.piece.name
                if let last = full.split(separator: "–").last {
                    return String(last).trimmingCharacters(in: .whitespaces)
                }
                return full
            }
            return BarSegment(id: z.id, name: names.joined(separator: " + "), film: z.film(rollWidth: rw), colorIndex: z.pieces.first?.piece.colorIndex ?? 0)
        }

        let rows: [PieceRow] = pieces.compactMap { p in
            guard let b = baseMap[p.id], let pl = nested.placements[p.id] else { return nil }
            let isNested = !pl.isNew && pl.zone.pieces.first?.piece.id != p.id
            return PieceRow(piece: p, baselineStrips: b.strips, baselineFilm: b.film,
                            zoneNumber: pl.zone.id + 1, rotated: pl.rotated,
                            nestedAlongside: isNested ? pl.zone.pieces.first?.piece.name : nil)
        }

        return Result(pieces: pieces, netArea: net, cutArea: cut,
                      baselineFilm: baseFilm, nestedFilm: nestedFilm,
                      baselineCost: cBase, nestedCost: cNest,
                      savingFilm: savFilm, savingCost: savCost, savingPct: savPct,
                      baselineSegments: baseSegments, nestedSegments: nestSegments, rows: rows)
    }
}
