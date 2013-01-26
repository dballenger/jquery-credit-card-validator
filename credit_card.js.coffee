root = exports ? this
Denetron = root.Denetron || {}
root.Denetron = Denetron

class Denetron.CreditCard
  cardPatterns: [
    {name: 'visa', pattern: /^4\d{12}(\d{3})?$/ }
    {name: 'master', pattern: /^(5[1-5]\d{4}|677189)\d{10}$/ }
    {name: 'discover', pattern: /^(6011|65\d{2})\d{12}$/ }
    {name: 'american_express', pattern: /^3[47]\d{13}$/ }
    {name: 'diners_club', pattern: /^3(0[0-5]|[68]\d)\d{11}$/ }
    {name: 'jcb', pattern: /^35(28|29|[3-8]\d)\d{12}$/ }
    {name: 'switch', pattern: /^6759\d{12}(\d{2,3})?$/ }
    {name: 'solo', pattern: /^6767\d{12}(\d{2,3})?$/ }
    {name: 'maestro', pattern: /^(5[06-8]|6\d)\d{10,17}$/ }
    {name: 'bogus', pattern: /^(1|2|3)$/ }
  ]
  constructor: (card_number) ->
    @card_number = jQuery.string(card_number).gsub(/[^\d]/, "").str
    @card_type   = @determineCardType()
    @valid       = ((@card_type != null) && jQuery.inArray(@card_type, CreditCard.enabledCardTypes) && @validateChecksum()) || @card_type == "bogus"
    @enabled     = jQuery.inArray(@card_type, CreditCard.enabledCardTypes)
    
  determineCardType: ->
    for card_type in @cardPatterns
      if @card_number.match card_type.pattern
        return card_type.name
    
    null
      
  validateChecksum: ->
    total = 0
    for i in [(@card_number.length-1)..0]
      n = +@card_number[i]
      if (i+@card_number.length) % 2 == 0
        n = if n * 2 > 9 then n * 2 - 9 else n * 2
      total += n
    total % 10 == 0
      
  @setEnabledCardTypes: (@enabledCardTypes) ->

(($) ->
  $.fn.validateCreditCard = ->
    @each ->
      $(this).blur ->
        credit_card = new Denetron.CreditCard(@value)
        
        if credit_card.valid
          $(this).parent().children("input[id*='_card_type']").val(credit_card.card_type)
          $(this).css("background-color", "#00FF7F")
          
          $(".credit_card_logo").each (i, logo) ->
            $(logo).css("opacity", "0.4")
            $(logo).css("filter", "alpha(opacity=40)")
          
          $("#" + credit_card.card_type + "_card").css("opacity", "1")
          $("#" + credit_card.card_type + "_card").css("filter", "alpha(opacity=100)")
        else
          $(this).parent().children("input[id*='_card_type']").val("")
          
          if credit_card.card_number != ""
            $(this).css("background-color", "red")
          else
            $(this).css("background-color", "#ffffff")
          
          $(".credit_card_logo").each (i, logo) ->
            $(logo).css("opacity", "1")
            $(logo).css("filter", "alpha(opacity=100)")
)(jQuery)

jQuery ->
  jQuery("input[id*='_card_number']").validateCreditCard()
  jQuery("input[id*='_card_number']").blur()