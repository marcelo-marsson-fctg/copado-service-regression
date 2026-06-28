*** Settings ***
Library    QForce

*** Variables ***
${BROWSER}                chrome


*** Keywords ***
Setup Browser
    Open Browser          about:blank                 ${BROWSER}
    ...    options=add_experimental_option("prefs", {"autofill.profile_enabled": False, "autofill.address_enabled": False, "credentials_enable_service": False, "profile.password_manager_enabled": False})
    SetConfig             LineBreak                   ${EMPTY}               #\ue000
    SetConfig             DefaultTimeout              30s                    #sometimes salesforce is slow
    SetConfig             CSSSelectors                False

End suite
    Close All Browsers


Login
    [Documentation]      Login to Salesforce instance Using JWT and MFA if needed
    Jwt Authenticate    ${client_id}    ${persona_username}    ${server_key}    sandbox=True
    Jwt Login           /lightning/page/home
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${MFA_needed}=       Run Keyword And Return Status          Should Not Be Equal    ${None}       ${persona_mfa_key}
    Run Keyword If       ${MFA_needed}               Fill MFA   ${persona_username}         ${persona_mfa_key}    ${login_url}
    ClickElement         App Launcher
    ClickItem            Home


Fill MFA
    [Documentation]      Gets the MFA OTP code and fills the verification dialog (if needed)
    [Arguments]          ${sf_username}=${username}    ${mfa_secret}=${secret}  ${sf_instance_url}=${login_url}
    ${mfa_code}=         GetOTP    ${sf_username}   ${mfa_secret}   ${login_url}  
    TypeSecret           Verification Code       ${mfa_code}      
    ClickText            Verify 


Home
    GoTo                 ${login_url}lightning/page/home
    ${login_status} =    IsText                      To access this page, you have to log in to Salesforce.    2
    Run Keyword If       ${login_status}             Login
    ClickText            Home
    VerifyTitle          Home | Salesforce