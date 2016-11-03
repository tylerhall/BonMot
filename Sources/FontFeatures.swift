//
//  FontFeatures.swift
//
//  Created by Brian King on 8/31/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

// This is not supported by watchOS
#if os(iOS) || os(tvOS) || os(OSX)

    /// Protocol to provide values to be used by `UIFontFeatureTypeIdentifierKey` and `UIFontFeatureSelectorIdentifierKey`.
    /// You can typically find these values in CoreText.SFNTLayoutTypes
    public protocol FontFeatureProvider {
        func featureSettings() -> [(type: Int, selector: Int)]
    }

    public extension BONFont {
        /// Create a new font and attempt to enable the specified font features. The returned font will have all
        /// features enabled that are supported by the font.
        /// - parameter withFeatures: the features to attempt to enable on the font
        /// - returns: a new font with the specified features enabled
        public func font(withFeatures featureProviders: [FontFeatureProvider]) -> BONFont {
            var fontAttributes = fontDescriptor.fontAttributes
            var features = fontAttributes[BONFontDescriptorFeatureSettingsAttribute] as? [StyleAttributes] ?? []
            if featureProviders.count > 0 {
                let newFeatures = featureProviders.map() { $0.featureAttributes() }.flatMap { $0 }
                features.append(contentsOf: newFeatures)
                fontAttributes[BONFontDescriptorFeatureSettingsAttribute] = features
            }
            let descriptor = BONFontDescriptor(fontAttributes: fontAttributes)
            #if os(OSX)
                return BONFont(descriptor: descriptor, size: pointSize)!
            #else
                return BONFont(descriptor: descriptor, size: pointSize)
            #endif
        }
    }

    /// A feature provider for changing the number case, also known as figure style.
    public enum NumberCase: FontFeatureProvider {

        /// Uppercase numbers, also known as lining figures, are the same height
        /// as uppercase letters, and they do not extend below the baseline.
        case upper

        /// Lowercase numbers, also known as oldstyle figures, are similar in
        /// size and visual weight to lowercase letters, allowing them to
        /// blend in better in a block of text. They may have descenders
        /// which drop below the typographic baseline.
        case lower

        public func featureSettings() -> [(type: Int, selector: Int)] {
            switch self {
            case .upper:
                return [(type: kNumberCaseType, selector: kUpperCaseNumbersSelector)]
            case .lower:
                return [(type: kNumberCaseType, selector: kLowerCaseNumbersSelector)]
            }
        }

    }

    /// A feature provider for changing the number spacing, also known as figure spacing.
    public enum NumberSpacing: FontFeatureProvider {

        /// Monospaced numbers, also known as tabular figures, each take up the
        /// same amount of horizontal space, meaning that different numbers will
        /// line up when arranged in columns.
        case monospaced

        /// Proportionally spaced numbers, also known as proprotional figures,
        /// are of variable width. This makes them look better in most cases,
        /// but they should be avoided when numbers need to line up in columns.
        case proportional

        public func featureSettings() -> [(type: Int, selector: Int)] {
            switch self {
            case .monospaced:
                return [(type: kNumberSpacingType, selector: kMonospacedNumbersSelector)]
            case .proportional:
                return [(type: kNumberSpacingType, selector: kProportionalNumbersSelector)]
            }
        }

    }

    /// A feature provider for changing the vertical position of characters.
    public enum VerticalPosition: FontFeatureProvider {

        /// No vertical position adjustment is applied.
        case normal

        /// Superscript (superior) glpyh variants are used, as in footnotes¹.
        case superscript

        /// Subscript (inferior) glyph variants are used: vₑ.
        case `subscript`

        /// Ordinal glyph variants are used, as in the common typesetting of 4th.
        case ordinals

        /// Scientific inferior glyph variants are used: H₂O
        case scientificInferiors

        public func featureSettings() -> [(type: Int, selector: Int)] {
            let selector: Int
            switch self {
            case .normal: selector = kNormalPositionSelector
            case .superscript: selector = kSuperiorsSelector
            case .`subscript`: selector = kInferiorsSelector
            case .ordinals: selector = kOrdinalsSelector
            case .scientificInferiors: selector = kScientificInferiorsSelector
            }
            return [(type: kVerticalPositionType, selector: selector)]
        }

    }

    /// A feature provider for changing small caps behavior.
    /// - Note: `fromUppercase` and `fromLowercase` can be combined: they are not
    /// mutually exclusive.
    public enum SmallCaps: FontFeatureProvider {

        /// No small caps are used.
        case disabled

        /// Uppercase letters in the source string are replaced with small caps.
        /// Lowercase letters remain unmodified.
        case fromUppercase

        /// Lowercase letters in the source string are replaced with small caps.
        /// Uppercase letters remain unmodified.
        case fromLowercase

        public func featureSettings() -> [(type: Int, selector: Int)] {
            switch self {
            case .disabled:
                return [
                    (type: kLowerCaseType, selector: kDefaultLowerCaseSelector),
                    (type: kUpperCaseType, selector: kDefaultUpperCaseSelector),
                ]
            case .fromUppercase:
                return [(type: kUpperCaseType, selector: kUpperCaseSmallCapsSelector)]
            case .fromLowercase:
                return [(type: kLowerCaseType, selector: kLowerCaseSmallCapsSelector)]
            }
        }

    }

    /// A feature provider for enabling stylistic alternates. The options can be
    /// combined: they are not mutually exclusive.
    public enum StylisticAlternates: FontFeatureProvider {
        case noAlternates
        case one(on: Bool)
        case two(on: Bool)
        case three(on: Bool)
        case four(on: Bool)
        case five(on: Bool)
        case six(on: Bool)
        case seven(on: Bool)
        case eight(on: Bool)
        case nine(on: Bool)
        case ten(on: Bool)
        case eleven(on: Bool)
        case twelve(on: Bool)
        case thirteen(on: Bool)
        case fourteen(on: Bool)
        case fifteen(on: Bool)
        case sixteen(on: Bool)
        case seventeen(on: Bool)
        case eighteen(on: Bool)
        case nineteen(on: Bool)
        case twenty(on: Bool)

        //swiftlint:disable:next cyclomatic_complexity
        public func featureSettings() -> [(type: Int, selector: Int)] {
            let selector: Int
            switch self {
            case .noAlternates: selector = kNoStylisticAlternatesSelector
            case .one(let on): selector = on ? kStylisticAltOneOnSelector : kStylisticAltOneOffSelector
            case .two(let on): selector = on ? kStylisticAltTwoOnSelector : kStylisticAltTwoOffSelector
            case .three(let on): selector = on ? kStylisticAltThreeOnSelector : kStylisticAltThreeOffSelector
            case .four(let on): selector = on ? kStylisticAltFourOnSelector : kStylisticAltFourOffSelector
            case .five(let on): selector = on ? kStylisticAltFiveOnSelector : kStylisticAltFiveOffSelector
            case .six(let on): selector = on ? kStylisticAltSixOnSelector : kStylisticAltSixOffSelector
            case .seven(let on): selector = on ? kStylisticAltSevenOnSelector : kStylisticAltSevenOffSelector
            case .eight(let on): selector = on ? kStylisticAltEightOnSelector : kStylisticAltEightOffSelector
            case .nine(let on): selector = on ? kStylisticAltNineOnSelector : kStylisticAltNineOffSelector
            case .ten(let on): selector = on ? kStylisticAltTenOnSelector : kStylisticAltTenOffSelector
            case .eleven(let on): selector = on ? kStylisticAltElevenOnSelector : kStylisticAltElevenOffSelector
            case .twelve(let on): selector = on ? kStylisticAltTwelveOnSelector : kStylisticAltTwelveOffSelector
            case .thirteen(let on): selector = on ? kStylisticAltThirteenOnSelector : kStylisticAltThirteenOffSelector
            case .fourteen(let on): selector = on ? kStylisticAltFourteenOnSelector : kStylisticAltFourteenOffSelector
            case .fifteen(let on): selector = on ? kStylisticAltFifteenOnSelector : kStylisticAltFifteenOffSelector
            case .sixteen(let on): selector = on ? kStylisticAltSixteenOnSelector : kStylisticAltSixteenOffSelector
            case .seventeen(let on): selector = on ? kStylisticAltSeventeenOnSelector : kStylisticAltSeventeenOffSelector
            case .eighteen(let on): selector = on ? kStylisticAltEighteenOnSelector : kStylisticAltEighteenOffSelector
            case .nineteen(let on): selector = on ? kStylisticAltNineteenOnSelector : kStylisticAltNineteenOffSelector
            case .twenty(let on): selector = on ? kStylisticAltTwentyOnSelector : kStylisticAltTwentyOffSelector
            }
            return [(type: kStylisticAlternativesType, selector: selector)]
        }
    }

    extension FontFeatureProvider {

        /// - returns: an array of dictionaries, each representing one feature for the attributes key in the font attributes
        func featureAttributes() -> [StyleAttributes] {
            let featureSettings = self.featureSettings()
            return featureSettings.map {
                return [
                    BONFontFeatureTypeIdentifierKey: $0.type,
                    BONFontFeatureSelectorIdentifierKey: $0.selector,
                    ]
            }
        }

    }

#endif
