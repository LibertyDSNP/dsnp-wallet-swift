import Foundation

extension MultiassetCryptoType {
    func titleForLocale(_ locale: Locale) -> String {
//        switch utilsType {
//        case .sr25519:
//            return R.string.localizable.sr25519SelectionTitle(preferredLanguages: locale.rLanguages)
//        case .ed25519:
//            return R.string.localizable.ed25519SelectionTitle(preferredLanguages: locale.rLanguages)
//        case .ecdsa:
//            return R.string.localizable.ecdsaSelectionTitle(preferredLanguages: locale.rLanguages)
//        }
        return "\(locale)"
    }

    func subtitleForLocale(_ locale: Locale) -> String {
//        switch utilsType {
//        case .sr25519:
//            return R.string.localizable.sr25519SelectionSubtitle(preferredLanguages: locale.rLanguages)
//        case .ed25519:
//            return R.string.localizable.ed25519SelectionSubtitle(preferredLanguages: locale.rLanguages)
//        case .ecdsa:
//            return R.string.localizable.ecdsaSelectionSubtitle(preferredLanguages: locale.rLanguages)
//        }
        return "\(locale)"
    }
}
