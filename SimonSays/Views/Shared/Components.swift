import SwiftUI

/// Small uppercase label used above section titles ("Support · Knowledge base").
struct Eyebrow: View {
    let text: String
    init(_ text: String) { self.text = text }
    var body: some View {
        Text(text.uppercased())
            .font(.caption.weight(.semibold))
            .tracking(0.8)
            .foregroundStyle(Theme.accent)
    }
}

/// A tappable card used on the hub screens.
struct NavCard<Destination: View>: View {
    let badge: String?
    let title: String
    let text: String
    let systemImage: String
    @ViewBuilder let destination: () -> Destination

    init(badge: String? = nil, title: String, text: String, systemImage: String, @ViewBuilder destination: @escaping () -> Destination) {
        self.badge = badge
        self.title = title
        self.text = text
        self.systemImage = systemImage
        self.destination = destination
    }

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(Theme.accent)
                    .frame(width: 36, height: 36)
                    .background(Theme.tint, in: RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading, spacing: 4) {
                    if let badge {
                        Text(badge)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(Theme.muted)
                    }
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(text)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            .padding(.vertical, 6)
        }
    }
}

/// Coloured pill used for tags.
struct Pill: View {
    let text: String
    var color: Color = Theme.accent
    var body: some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12), in: Capsule())
            .foregroundStyle(color)
    }
}

/// Highlighted note block.
struct Callout: View {
    let title: String?
    let text: String
    var color: Color = Theme.accent
    init(_ text: String, title: String? = nil, color: Color = Theme.accent) {
        self.text = text
        self.title = title
        self.color = color
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title).font(.subheadline.weight(.semibold))
            }
            Text(text).font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(color.opacity(0.25)))
    }
}

/// A metric tile (label / big value / footnote).
struct MetricCard: View {
    let label: String
    let value: String
    var sub: String? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label).font(.caption).foregroundStyle(.secondary)
            Text(value).font(.title3.weight(.semibold)).minimumScaleFactor(0.7).lineLimit(1)
            if let sub {
                Text(sub).font(.caption2).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Theme.tint, in: RoundedRectangle(cornerRadius: 10))
    }
}

/// Prose section: a heading followed by paragraphs.
struct Prose: View {
    let heading: String?
    let paragraphs: [String]
    init(_ heading: String? = nil, _ paragraphs: [String]) {
        self.heading = heading
        self.paragraphs = paragraphs
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let heading {
                Text(heading).font(.title3.weight(.semibold))
            }
            ForEach(paragraphs.indices, id: \.self) { i in
                Text(paragraphs[i]).font(.body)
            }
        }
    }
}

/// Pre-filled mailto button, mirroring the site's "Ask about…" links.
struct EmailButton: View {
    let title: String
    let subject: String
    let message: String
    let prominent: Bool

    init(title: String, subject: String, body: String, prominent: Bool = true) {
        self.title = title
        self.subject = subject
        self.message = body
        self.prominent = prominent
    }

    var url: URL? {
        var c = URLComponents()
        c.scheme = "mailto"
        c.path = Theme.contactEmail
        c.queryItems = [URLQueryItem(name: "subject", value: subject), URLQueryItem(name: "body", value: message)]
        return c.url
    }

    var body: some View {
        if let url {
            if prominent {
                Link(destination: url) {
                    Label(title, systemImage: "envelope.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            } else {
                Link(destination: url) {
                    Label(title, systemImage: "envelope")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

/// Standard site disclaimer footer.
struct DisclaimerFooter: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.top, 8)
    }
}

/// Numeric text field bound to a Double.
struct NumberField: View {
    let label: String
    @Binding var value: Double
    var decimals: Int = 2
    var suffix: String? = nil

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField("0", value: $value, format: .number.precision(.fractionLength(0...decimals)))
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 120)
            if let suffix {
                Text(suffix).foregroundStyle(.secondary)
            }
        }
    }
}
