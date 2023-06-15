//
//  AccessiblityIdentifiers.swift
//  DSNP-Wallet
//
//  Created by Ben Gabay on 5/18/23.
//

import Foundation

struct AccessibilityIdentifier {
    
    // Onboarding
    struct OnboardingIdentifiers {
        
        // Sign In Screen
        static let createNewUserButton = "onboarding.signIn.newUserButton"
        static let createUserMeWeButton = "onboarding.signIn.meweButton"
        static let restoreUserButton = "onboarding.signIn.restoreButton"

        // Claim Handle
        static let claimHandleTextfield = "onboarding.claimHandle.claimHandleTextfield"
        static let claimHandleNextButton = "onboarding.claimHandle.claimHandleButton"
        static let skipButton = "onboarding.claimHandle.skipButton"

        // Confirm Handle
        static let confirmHandleButton = "onboarding.confirmHandle.nextButton"
        static let confirmHandleLabel = "onboarding.confirmHandle.handleLabel"
        
        // Agree to terms
        static let agreeConfirmHandleLabel = "onboarding.agreeToTerms.handleLabel"
        static let agreeButton = "onboarding.agreeToTerms.agreeButton"

        // Congrats Modal
        static let congratsFinishButton = "onboarding.congrats.finishButton"
        static let congratsSkipButton = "onboarding.congrats.skipButton"
        static let congratsCloseButton = "onboarding.congrats.closeButton"
    }
    
    // Seed Phrase Flow
    struct SeedPhraseIdentifier {
        
        // Showing Seed Phrase Screen
        static let seedPhraseListIdentifierA = "seedphrase.seedphraseListA"
        static let seedPhraseListIdentifierB = "seedphrase.seedphraseListB"
        static let seedPhraseListWrittenButton = "seedphrase.seedPhraseListWrittenButton"

    }
    
    struct SeedPhraseTestIdentifier {
        // Showing Seed Phrase Test Screen
        static let seedPhraseTestListIdentifierA = "seedphrase.seedphraseTestListA"
        static let seedPhraseTestListIdentifierB = "seedphrase.seedphraseTestListB"
        static let seedPhraseTestWordBank = "seedphrase.seedPhraseTestWordBank"
        static let seedPhraseTestContinueButton = "seedphrase.seedPhraseTestContinueButton"
    }
    
    // Tab View
    struct TabView {
        struct ProfileViewIdentifiers {
            // Profile Image
            static let profileImage = "tabView.profile.profileImage"

            // Fields
            static let profileIdentifierFirstNameField = "tabView.profile.firstNameField"
            static let profileIdentifierLastNameField = "tabView.profile.lastNameField"
            static let profileIdentifierEmailField = "tabView.profile.emailField"

            // Buttons
            static let saveButton = "tabView.profile.saveButton"
            static let editButton = "tabView.profile.editButton"
        }
        
        struct SettingsViewIdentifiers {
            // Headline
            static let settingsHeadline = "tabView.settings.headline"

            static let revealPhraseButton = "tabView.settings.revealPhraseButton"
            
            // List Items
            static let security = "tabView.settings.security"
            static let faceId = "tabView.settings.faceId"
            static let faceIdToggle = "tabView.settings.faceIdToggle"
            static let password = "tabView.settings.password"
            static let logoutButton = "tabView.settings.logoutButton"
        }
        
        struct IdentityViewIdentifiers {
            // Headline
            static let profileImage = "tabView.id.profile"
            static let handle = "tabView.id.handle"

            // Buttons
            static let progressIndicator = "tabView.id.progress"
            static let seeAllButton = "tabView.id.seeAll"

            // Claim FRQCY
            static let claimNowButton = "tabView.id.claimNowButton"
            static let initialClaimBanner = "tabView.settings.claimNowBanner"
        }
    }
}
