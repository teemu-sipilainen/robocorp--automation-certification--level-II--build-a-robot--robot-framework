*** Comments ***
# Robocorp
# Course: Automation Certification Level 2: Build a robot - Robot Framework
# https://robocorp.com/docs-robot-framework/courses/beginners-course
# Started 15.12.2024
# Updated 15.12.2024
# Teemu Sipiläinen


*** Settings ***
Documentation       Orders robots from RobotSpareBin Industries Inc.
...                 Saves the order HTML receipt as a PDF file.
...                 Saves the screenshot of the ordered robot.
...                 Embeds the screenshot of the robot to the PDF receipt.
...                 Creates ZIP archive of the receipts and the images.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.HTTP
Library             RPA.Tables


*** Variables ***
${ok_button}    xpath://button[@class='btn btn-dark']


*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Open the robot order website
    Download the CSV file
    Close the annoying modal
    Fill the form using the data from the CSV file


*** Keywords ***
Open the robot order website
    Open Browser    https://robotsparebinindustries.com/#/robot-order
    Maximize Browser Window

Download the CSV file
    Download    https://robotsparebinindustries.com/orders.csv    overwrite=True

Fill the form using the data from the CSV file
    ${orders} =    Get orders
    Log    ${orders}
    FOR    ${order}    IN    @{orders}
        Log    ${order}
        Log    ${order}[Legs]
        Log    ${order}[Address]
        Fill the form    ${order}
    END

Get orders
    ${orders} =    Read table from CSV    orders.csv    header=True
    RETURN    ${orders}

Fill the form
    [Arguments]    ${order}
    Select From List By Value    head    ${order}[Head]
    Select Radio Button    body    ${order}[Body]
    Input Text    xpath://input[@type="number" and @placeholder="Enter the part number for the legs"]    ${order}[Legs]
    Input Text    address    ${order}[Address]
    Click Element    id:preview

    WHILE    ${True}
        ${Order Button Exists} =    Does Page Contain Element    id:order
        IF    ${Order Button Exists} == False    BREAK

        Scroll Element Into View    //*[@id="order"]
        Wait Until Element Is Visible    id:order
        Wait Until Element Is Enabled    id:order
        Click Element    id:order
    END

    Click Element    id:order-another
    Close the annoying modal

Close the annoying modal
    Wait Until Element Is Visible    ${ok_button}
    Click Element    ${ok_button}
