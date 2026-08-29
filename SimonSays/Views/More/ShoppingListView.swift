import SwiftUI

struct ShopItem: Identifiable {
    let name: String
    let url: String
    var id: String { url }
    var link: URL? { URL(string: url) }
}

struct ShoppingListView: View {
    private let amazon: [ShopItem] = [
        .init(name: "TRESKO water boiler, 6.8 L", url: "https://www.amazon.nl/dp/B0BHDPNR95?tag=simoncrooke00-21"),
        .init(name: "KitchenBoss Sous Vide Garer Stick Precision Cooker", url: "https://www.amazon.nl/dp/B07BQLMVVY?tag=simoncrooke00-21"),
        .init(name: "Trixie Car Cooler", url: "https://www.amazon.nl/dp/B0102ZYFCQ?tag=simoncrooke00-21"),
        .init(name: "Sealey Paint Dirt Removal Pen", url: "https://www.amazon.nl/dp/B088LYDXQ4?tag=simoncrooke00-21"),
        .init(name: "Sealey Paint Dirt Removal — replacement needle pack (for MK78 pen)", url: "https://www.amazon.nl/dp/B088X2FB9G?tag=simoncrooke00-21")
    ]

    private let glansz: [ShopItem] = [
        .init(name: "Teflon Squeegee tape waterproof 5m", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/squeegee-tape-super-smooth-5m/"),
        .init(name: "SOTT SpeedWing Cherry Squeegee 11cm", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/speedwing-cherry-rakel-11cm/"),
        .init(name: "Profilm Squeegee full set", url: "https://glansz.nl/profilm/profilm-squeegee-set-6-verschillende/"),
        .init(name: "Labocosmetica PPF Slipum Squeegee Set", url: "https://glansz.nl/labocosmetica/ppf-slipum-squeegee-set-labocosmeta/"),
        .init(name: "Colad Pump sprayer 1L", url: "https://glansz.nl/hulpmiddelen/dosering-flacons/pompspuit-1l-colad/"),
        .init(name: "SOTT The Squad — Factotum + Crawler (pair of tuck tools)", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/the-squad-ppf-rakels/"),
        .init(name: "Yellotools BodyGuard Backingpaper Knife", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/bodyguardknife-teflon-backing-paper-cut/"),
        .init(name: "NT Cutter A-553, 30 degrees", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/nt-cutter-a-553-30-s/"),
        .init(name: "NT CUTTER BD-2000 9mm 100pcs", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/nt-cutter-reservemes-ba-50-9mm-50-st-2/"),
        .init(name: "OLFA, SCS-2 Scissors – 170 mm", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/olfa-scissor-stainless-serrated-edge-5/"),
        .init(name: "PPF Tool, Syringe with needle", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/ppf-tool-spuit-met-naald/"),
        .init(name: "Yellotools GeckoPatch Large PPF magnet", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/geckopatch-power-strong-magnetic-pad-l/"),
        .init(name: "SOTT The Goliath Large Magnet", url: "https://glansz.nl/profilm-producten/ppf-tools-accessoires/sott-the-goliath-magnet-extra-large-24kg/"),
        .init(name: "Ma-Fra Panno Martina Chamois", url: "https://glansz.nl/wassen/droogdoeken-zemen/zeem-pva-panno-martina-mafra/"),
        .init(name: "Osmosis water wall model", url: "https://glansz.nl/machines/osmose/osmosewater-wand-oxmose/"),
        .init(name: "Libera Alkaline TFR 1000 ML", url: "https://glansz.nl/labocosmetica-producten/prewash-shampoo/libera-alkaline-tfr-1000-ml/"),
        .init(name: "Limpia Deep PPF & wraps Cleanser 500 ML", url: "https://glansz.nl/labocosmetica-producten/prewash-shampoo/limpia-deep-ppf-wraps-cleanser-500-ml/"),
        .init(name: "Renova, Acid PPF/Wrap Shampoo 500 ML", url: "https://glansz.nl/labocosmetica-producten/prewash-shampoo/renova-shampoo-for-ppf-wraps-500-ml/"),
        .init(name: "Armorius Gloss PPF Coating 20ML", url: "https://glansz.nl/labocosmetica-producten/ceramic-coating/ceramic-coating-armorius-ppf-gloss-20ml/"),
        .init(name: "Armorius Matt PPF Coating 20ML", url: "https://glansz.nl/labocosmetica-producten/ceramic-coating/ceramic-coating-armorius-ppf-matt-20ml/"),
        .init(name: "Armorius PPF Slip Solution 1000ML", url: "https://glansz.nl/exterieur/beschermen/armorius-ppf-slip-solution-1000-ml/"),
        .init(name: "Armorius PPF Tack Booster 1000ML", url: "https://glansz.nl/exterieur/beschermen/armorius-ppf-tack-booster-1000-ml/"),
        .init(name: "Armorius PPF Surface Reset 1000ML", url: "https://glansz.nl/exterieur/beschermen/armorius-ppf-surface-reset-1000-ml/"),
        .init(name: "Glansz Training Courses: PPF and much more", url: "https://glansz.nl/trainingen/"),
        .init(name: "Profilm ProCut 2.0 software (30 days)", url: "https://glansz.nl/profilm/profilm-30-dagen-licence/"),
        .init(name: "Profilm ProCut 2.0 software (365 days)", url: "https://glansz.nl/profilm/profilm-365-dagen-licence/")
    ]

    var body: some View {
        List {
            Section {
                Text("A working list of the kit Simon uses for paint protection film installation. Two parts: items available on Amazon and specialist supplies distributed by Glansz.")
                    .font(.subheadline).foregroundStyle(.secondary)
            }
            Section {
                ForEach(amazon) { item in row(item, action: "Buy on Amazon.nl") }
            } header: {
                Text("1. Amazon affiliate items")
            } footer: {
                Text("These items have Amazon affiliate links. If you buy through one of them, simonsays.coach earns a small commission at no extra cost to you. The links point to Amazon.nl. If you are ordering from Belgium or Germany, search your own Amazon store for the same product.")
            }
            Section {
                ForEach(glansz) { item in row(item, action: "View on glansz.nl") }
            } header: {
                Text("2. Specialist PPF supplies (via Glansz)")
            } footer: {
                Text("These items are distributed in the Netherlands and Belgium by Glansz, where Simon holds a day role at his employer. simonsays.coach earns no affiliate commission on Glansz purchases. They're listed because they're the tools and chemicals Simon uses on the bench.")
            }
        }
        .navigationTitle("PPF Shopping List")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ item: ShopItem, action: String) -> some View {
        Group {
            if let url = item.link {
                Link(destination: url) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name).foregroundStyle(.primary)
                            Text(action).font(.caption).foregroundStyle(Theme.accent)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right.square").foregroundStyle(.secondary)
                    }
                }
            } else {
                Text(item.name)
            }
        }
    }
}

#Preview {
    NavigationStack { ShoppingListView() }
}
