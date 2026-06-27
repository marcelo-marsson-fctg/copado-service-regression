*** Settings ***
Library             QForce
Suite Setup         Setup Browser
Suite Teardown      End suite 
Resource            ../resources/common.resource


*** Variables ***
${BROWSER}          chrome


*** Test Cases ***
Login Via JWT And Open Home
    [Documentation]    JWT Bearer auth as a precondition, then verify the Home page loads.
    [Tags]    login    smoke
    OpenBrowser         about:blank    chrome
    Login
    VerifyTitle         Home | Salesforce


*** Keywords ***
Setup Browser
    Set Library Search Order    QForce    QWeb
    Open Browser        about:blank    ${BROWSER}
    SetConfig           LineBreak           ${EMPTY}        #\ue000
    SetConfig           DefaultTimeout      30s
    SetConfig           CSSSelectors        False

End suite
    Close All Browsers