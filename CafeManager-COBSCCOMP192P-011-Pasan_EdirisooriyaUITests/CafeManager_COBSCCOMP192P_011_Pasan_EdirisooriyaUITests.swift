
//
//  CafeManager_COBSCCOMP192P_011_Pasan_EdirisooriyaUITests.swift
//  CafeManager-COBSCCOMP192P-011-Pasan_EdirisooriyaUITests
//
//  Created by Pasan Induwara Edirisooriya on 4/11/21.
//

import XCTest

class CafeManager_COBSCCOMP192P_011_Pasan_EdirisooriyaUITests: XCTestCase {

    func testLaunchPerformance() {
      if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
          XCUIApplication().launch()
        }
      }
    }
    
    //MARK:Sign Up Test Case
    func testSignUp(){
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Sign Up"]/*[[".buttons[\"Sign Up\"].staticTexts[\"Sign Up\"]",".staticTexts[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let emailTextField = elementsQuery.textFields["Email"]
        emailTextField.tap()
        elementsQuery.buttons["REGISTER"].tap()
        app.alerts["Error"].scrollViews.otherElements.buttons["OK"].tap()
        emailTextField.tap()
        
        let phoneNumberTextField = elementsQuery.textFields["Phone Number"]
        phoneNumberTextField.tap()
        phoneNumberTextField.tap()
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        
        let confirmPasswordSecureTextField = elementsQuery.secureTextFields["Confirm Password"]
        confirmPasswordSecureTextField.tap()
        confirmPasswordSecureTextField.tap()

        
    }
    
    //MARK:Login Test Case
    func testLogin(){
        
        let app = XCUIApplication()
        let elementsQuery = app.scrollViews.otherElements
        let loginStaticText = elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["LOGIN"]/*[[".buttons[\"LOGIN\"].staticTexts[\"LOGIN\"]",".staticTexts[\"LOGIN\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        loginStaticText.tap()
        
        let okButton = app.alerts["Error"].scrollViews.otherElements.buttons["OK"]
        okButton.tap()
        elementsQuery.textFields["Email"].tap()
        
        let passwordSecureTextField = elementsQuery.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        loginStaticText.tap()
        okButton.tap()
 
    }
 
    //MARK:Forgot Password Test Case
    func testForgetPassword(){
        
        let app = XCUIApplication()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["Forgot Password"]/*[[".buttons[\"Forgot Password\"].staticTexts[\"Forgot Password\"]",".staticTexts[\"Forgot Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Please input the email address that you registered before to active the acccount").element.tap()
        elementsQuery.buttons["SUBMIT"].tap()
        
        let okButton = app.alerts["Error"].scrollViews.otherElements.buttons["OK"]
        okButton.tap()
        scrollViewsQuery.otherElements.containing(.image, identifier:"logo_main").children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element.tap()
        elementsQuery/*@START_MENU_TOKEN@*/.staticTexts["SUBMIT"]/*[[".buttons[\"SUBMIT\"].staticTexts[\"SUBMIT\"]",".staticTexts[\"SUBMIT\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        okButton.tap()
        
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
