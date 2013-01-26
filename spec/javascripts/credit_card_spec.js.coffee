#= require jquery
#= require jquery.string.1.1.0
#= require credit_card

describe "Credit Card object", ->
  beforeEach ->
    Denetron.CreditCard.setEnabledCardTypes(["american_express", "bogus", "discover", "master", "visa"])
    
  it "Detects bogus card properly", ->
    expect(new Denetron.CreditCard("1").card_type).toEqual("bogus")
    expect(new Denetron.CreditCard("2").card_type).toEqual("bogus")
    expect(new Denetron.CreditCard("3").card_type).toEqual("bogus")
  
  it "Detects american express cards properly", ->
    expect(new Denetron.CreditCard("378282246310005").card_type).toEqual("american_express")
  
  it "Detects discover cards properly", ->
    expect(new Denetron.CreditCard("6011000990139424").card_type).toEqual("discover")
  
  it "Detects master cards properly", ->
    expect(new Denetron.CreditCard("5105105105105100").card_type).toEqual("master")
  
  it "Detects visa cards properly", ->
    expect(new Denetron.CreditCard("4012888888881881").card_type).toEqual("visa")
    
  it "Detects valid credit cards", ->
    expect(new Denetron.CreditCard("4012888888881881").valid).toBeTruthy()
  
  it "Detects if a card is invalid because of the checksum", ->
    expect(new Denetron.CreditCard("4012888888881880").valid).toBeFalsy()
    
  it "Properly detects if card type is enabled", ->
    expect(new Denetron.CreditCard("4012888888881880").card_type).toEqual("visa")
    expect(new Denetron.CreditCard("4012888888881880").enabled).toBeTruthy()
    
  it "Changes background and changes opacity of logos for invalid card", ->
    loadFixtures "credit_card_form"
    
    jQuery("#credit_card_card_number").validateCreditCard()
    field = jQuery("#credit_card_card_number")
    field.val("1234")
    field.blur()
    expect(field.css("background-color")).toEqual("rgb(255, 0, 0)")
    
    logo = jQuery("#bogus_card")
    expect(logo.css("opacity")).toEqual("1")
    
    logo = jQuery("#american_express_card")
    expect(logo.css("opacity")).toEqual("1")
    
  it "Changes background and changes opacity of logos for valid card", ->
    loadFixtures "credit_card_form"

    jQuery("#credit_card_card_number").validateCreditCard()
    field = jQuery("#credit_card_card_number")
    
    field.val("1")
    field.blur()
    expect(field.css("background-color")).toEqual("rgb(0, 255, 127)")
    expect(jQuery("#credit_card_card_type").val()).toEqual("bogus")
    
    logo = jQuery("#bogus_card")
    expect(logo.css("opacity")).toEqual("1")
    
    logo = jQuery("#american_express_card")
    expect(logo.css("opacity")).toEqual("0.4")