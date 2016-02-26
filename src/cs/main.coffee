isArticleLoading = false
isFeedLoading = false
isNewsLoading = false
isJobsLoading = false
vpgrid = null
###

###
class NewsItem
  constructor: (target) ->
    @target = target

  template: (item) ->
    alert("Not implemented")

  render: (item) ->
    alert("Not implemented")

###

###
class NewsFeedItem extends NewsItem
  template: (item) ->
    t = "
    <article class=\"item feed-preview\" data-articleid=\""+item.Id+"\">
      <header><a href=\""+item.Url+"\">"+item.Headline+"</a></header>"
    t += "<img src=\""+item.Image+"\"/>" if item.Image?
    t += "
      <div class=\"text\">
        <p>"+item.Teaser+"</p>
      </div>
      <div class=\"clearfix\"/>
     </article>
    "

  render: (item) ->
    @target.append this.template(item)
###

###
class NewsArticleItem extends NewsItem
  template: (item) ->
    "
      <article class=\"item article-preview\" data-articleid=\""+item.Id+"\">
        <img src=\""+item.Image+"\"/>
        <div class=\"text\">
            <header><a href=\""+item.Url+"\">"+item.Headline+"</a></header>
            <p>"+item.Teaser+"</p>
        </div>
        <div class=\"clearfix\"></div>
      </article>
    "

  render: (item) ->
    @target.append this.template(item)
###

###
class JobItem extends NewsItem
  template: (item) ->
  
    description = "" 
    metadata = ""
    if (item.Description?.length)
      description = "<p>" + item.Description + "</p>"
    if (item.Metadata?.length)
      metadata = "<div class=\"meta\">" + item.Metadata + "</div>"
      
    "
        <article class=\"item job\">
            <header>
                <a href=\"" + item.Url + "\" target=\"_blank\">" + item.Title + "</a>
            </header>
            <div class=\"text\">
                <div class=\"post-date\">Posted on: " + item.Date + "</div>" + description + metadata + "<div></article>"
                
  
  render: (item) ->
    @target.append this.template(item)
###


###
class NewsFeedLoader
  constructor: (bottomDelta) ->
    @delta = bottomDelta

  register: () ->
    _delta = @delta
    _load = this.load
    $(window).scroll () ->
      _load() if $('#column-left').height() - $(window).height() - $(window).scrollTop() < _delta and not isFeedLoading
#    $(document).bind 'touchmove', () ->
#      _load() if $('#column-left').height() - $(window).height() - $(window).scrollTop() < _delta and not isFeedLoading
    _load()

  load: ->
    isFeedLoading = true
    numItems = $("#inner-left").find(".item").length
    if numItems < 280
      $('.pager-loading').show()
      data = { "a":"news", "c":20, "s":numItems }
      jqXHR = $.getJSON("/ajax-actions", data)
      jqXHR.done (json) ->
        for item in json.data.Articles
          do () ->
            obj = new NewsFeedItem($("#inner-left"))
            obj.render(item)
        $('.pager-loading').hide()
        isFeedLoading = false
      jqXHR.error () ->
        $("#main .pager").show()
        $('.pager-loading').hide()
        isFeedLoading = false
    else
      $("#main .pager").show()
      $('.pager-loading').hide()

###

###
class NewsLoader
  constructor: (bottomDelta) ->
    @delta = bottomDelta

  register: () ->
    _delta = @delta
    _load = this.load
    $(window).scroll () ->
      _load() if $('#column-full').height() - $(window).height() - $(window).scrollTop() < _delta and not isNewsLoading
#    $(document).bind 'touchmove', () ->
#      _load() if $('#column-full').height() - $(window).height() - $(window).scrollTop() < _delta and not isNewsLoading
    _load()

  load: ->
    isNewsLoading = true
    numItems = $("#inner-full").find(".item").length
    rootNodeId = $("#inner-full").attr("data-root");
    if numItems < 280
      $('.pager-loading').show()
      data = { "a":"any", "r":rootNodeId, "c":20, "s":numItems }
      jqXHR = $.getJSON("/ajax-actions", data)
      jqXHR.done (json) ->
        for item in json.data.Articles
          do () ->
            obj = new NewsArticleItem($("#inner-full"))
            obj.render(item)
        $('.pager-loading').hide()
        isNewsLoading = false
      jqXHR.error () ->
        $("#main .pager").show()
        $('.pager-loading').hide()
        isNewsLoading = false
    else
      $("#main .pager").show()
      $('.pager-loading').hide()

###

###
class NewsArticleLoader
  constructor: (bottomDelta) ->
    @delta = bottomDelta

  register: () ->
    _delta = @delta
    _load = this.load
    $(window).scroll () ->
      _load() if $('#column-center').height() - $(window).height() - $(window).scrollTop() < _delta and not isArticleLoading
#    $(document).bind 'touchmove', () ->
#      _load() if $('#column-center').height() - $(window).height() - $(window).scrollTop() < _delta and not isArticleLoading
    _load()

  load: ->
    isArticleLoading = true
    numItems = $("#inner-center").find(".item").length
    if numItems < 100
      $('.pager-loading').show()
      data = { "a":"features", "c":20, "s":numItems }
      jqXHR = $.getJSON("/ajax-actions",data)
      jqXHR.done (json) ->
        for item in json.data.Articles
          do () ->
            obj = new NewsArticleItem($('#inner-center'))
            obj.render(item)
        $('.pager-loading').hide()
        isArticleLoading = false
      jqXHR.error () ->
        $("#main .pager").show()
        $('.pager-loading').hide()
        isArticleLoading = false
    else
      $("#main .pager").show()
      $('.pager-loading').hide()
###


###        
class JobsLoader
  constructor: (bottomDelta) ->
    @delta = bottomDelta

  register: () ->
    _delta = @delta
    _load = this.load
    $(window).scroll () ->
      _load() if $('#column-full').height() - $(window).height() - $(window).scrollTop() < _delta and not isJobsLoading
#    $(document).bind 'touchmove', () ->
#      _load() if $('#column-full').height() - $(window).height() - $(window).scrollTop() < _delta and not isJobsLoading
    _load()

  load: ->
    isJobsLoading = true
    numItems = $('#inner-job-listing').find(".item").length
    if numItems < 200
      $('.pager-loading').show()
      data = { "a":"jobs", "c":20, "s":numItems }
      jqXHR = $.getJSON("/ajax-actions", data)
      jqXHR.done (json) ->
        for item in json.data.JobList
          do () ->
            obj = new JobItem($('#inner-job-listing'))
            obj.render(item)
        $('.pager-loading').hide()
        isJobsLoading = false
      jqXHR.error () ->
        $("#main .pager").show()
        $('.pager-loading').hide()
        isJobsLoading = false
    else
      $("#main .pager").show()
      $('.pager-loading').hide()


###


###   
class RegWall
  register: () ->
    _login = this.login
    _reg = this.reg
    _login() 
    _reg()
    
    
    
  login: () ->

  $('#signin .form-signin').keyup (event) ->
      code = event.which;
      if code is 13
        $('#regwall-signin').trigger("click");
        event.preventDefault();
    
    $('#regwall-signin').click (e) ->
      e.preventDefault() 
      u = document.location + '?loggedin#premium';
      user = $('#regwall-email').val();
      pass = $('#regwall-pwd').val();
      #rem = $('#regwall-remember-me').is(":checked");
      rem = false
      data = { "a":"l", "user":user, "pass":pass, "rem":rem }
      jqXHR = $.ajax( {
        type: 'POST'
        url:'/ajax-actions',
        data: data,
        dataType: 'JSON' 
      })
      jqXHR.done (json) ->
        document.location = u if json.response == 'valid'
        $('#regwall-pwd-error').html(json.data) if json.response == 'invalid'
      jqXHR.error () ->
        alert(error)

  reg: () ->
    $('#register .form-signin').keyup (event) ->
      code = event.which;
      if code is 13
        $('#regwall-register').trigger("click");
        event.preventDefault();
    
    $('#regwall-register').click (e) ->
      e.preventDefault()
      $('#regwall-signin-error').addClass("hidden")
      u = '/register?email=' + $('#regwall-email-reg').val() + '&page=' + $('#regwall-page').val()
      user = $('#regwall-email-reg').val(); 
      data = { "a":"uc", "user":user} 
      jqXHR = $.ajax( {
        type: 'POST'
        url:'/ajax-actions',
        data: data,
        dataType: 'JSON' 
      })
      jqXHR.done (json) ->
        document.location = u if json.response == 'valid'
        $('#regwall-signin-error').removeClass("hidden") if json.response == 'invalid'
      jqXHR.error () ->
        alert(error)   
      
     
      
      
###


###  
class RHSSignup
  register: () ->
    _reg = this.reg
    _reg()
    
  reg: () ->
    bindEnter($('#rhs-form-signin'), $('#rhs-register'));  
    $('#rhs-register-btn').click (e) ->
      e.preventDefault()
      document.location = '/register?email=' + $('#rhs-email-reg').val() 
###


###
class Search
  register: () ->
    _search = this.search
    _search()

  search: () ->
    $('#search-button').click (e) ->
      e.preventDefault()
      term = $("#search").val()
      target = $(this).attr("data-target")
      if term?.length
        term = encodeURIComponent(term)
        document.location.href = "#{target}?q=#{term}" 

###


###        
class SearchLoader
  constructor: (bottomDelta) ->
    @delta = bottomDelta

  register: () ->
    _delta = @delta
    _load = this.load
    $(window).scroll () ->
      _load() if $('#column-full').height() - $(window).height() - $(window).scrollTop() < _delta and not isNewsLoading
#    $(document).bind 'touchmove', () ->
#      _load() if $('#column-full').height() - $(window).height() - $(window).scrollTop() < _delta and not isNewsLoading
    _load()

  load: ->
    isNewsLoading = true
    numItems = $('#inner-search-results').find(".item").length
    term = $('#inner-search-results').attr('data-searchterm')
    if numItems < 200
      $('.pager-loading').show()
      data = { "a":"sr", "t":term, "c":20, "s":numItems }
      jqXHR = $.getJSON("/ajax-actions", data)
      jqXHR.done (json) ->
        for item in json.data.Articles
          do () ->
            obj = new NewsArticleItem($('#inner-search-results'))
            obj.render(item)
        $('.pager-loading').hide()
        isNewsLoading = false
      jqXHR.error () ->
        $("#main .pager").show()
        $('.pager-loading').hide()
        isNewsLoading = false
    else
      $("#main .pager").show()
      $('.pager-loading').hide()

###



###
class ROICalculator

  constructor: (roiform) ->
    @roiform = roiform
    @searchQueriesByDay = $('#search-queries-by-day')
    @searchQueriesNoResults = $('#search-queries-no-result')
    @searchQueriesWithResults = $('#search-queries-with-result')
    @searchQueriesWithPurchase = $('#search-queries-with-purchase')
    @aveSpendPerItem = $('#ave-spend-per-item')

    @noResultsNotInCat = $('#no-results-item-not-in-cat')
    @noResultsNotInCatMissed = $('#no-results-item-not-in-cat-daily-missed-opps')
    @noResultsNotInCatConverted = $('#no-results-item-not-in-cat-converted')
    @noResultsNotInCatConvertedClicks = $('#no-results-item-not-in-cat-converted-clicks')
    @noResultsNotInCatConvertedRevDay = $('#no-results-item-not-in-cat-converted-rev-daily')
    @noResultsNotInCatConvertedRevMonth = $('#no-results-item-not-in-cat-converted-rev-monthly')
    @noResultsNotInCatConvertedRevAnnual = $('#no-results-item-not-in-cat-converted-rev-annually')

    @noResultsMisspelled = $('#no-results-item-misspelled')
    @noResultsMisspelledMissed = $('#no-results-item-misspelled-daily-missed-opps')
    @noResultsMisspelledConverted = $('#no-results-item-misspelled-converted')
    @noResultsMisspelledConvertedClicks = $('#no-results-item-misspelled-converted-clicks')
    @noResultsMisspelledConvertedRevDay = $('#no-results-item-misspelled-converted-rev-daily')
    @noResultsMisspelledConvertedMonth = $('#no-results-item-misspelled-converted-rev-monthly')
    @noResultsMisspelledConvertedAnnual = $('#no-results-item-misspelled-converted-rev-annually')

    @noResultsTotal = $('#no-results-item-total')
    @noResultsTotalMissed = $('#no-results-item-total-missed-opps')
    @noResultsTotalConvertedClicks = $('#no-results-item-total-converted-clicks')
    @noResultsTotalContvertedRevDay = $('#no-results-item-total-converted-rev-daily')
    @noResultsTotalConvertedRevMonth = $('#no-results-item-total-converted-rev-monthly')
    @noResultsTotalConvertedRevAnnual = $('#no-results-item-total-converted-rev-annually')

    @resultsItemNearTop = $('#results-item-near-top')
    @resultsItemInList = $('#results-item-in-list')

    @resultsUserGivesUp = $('#results-user-gives-up')
    @resultsUserGivesUpMissed = $('#results-user-gives-up-daily-missed-opps')
    @resultsUserGivesUpConverted = $('#results-user-gives-up-converted')
    @resultsUserGivesUpConvertedClicks = $('#results-user-gives-up-converted-clicks')
    @resultsUserGivesUpConvertedRevDay = $('#results-user-gives-up-converted-rev-daily')
    @resultsUserGivesUpConvertedRevMonth = $('#results-user-gives-up-converted-rev-monthly')
    @resultsUserGivesUpConvertedRevAnnual = $('#results-user-gives-up-converted-rev-annually')

    @resultsTotal = $('#results-total')
    @resultsTotalConvertedClicks = $('#results-item-total-converted-clicks')
    @resultsTotalConvertedRevDay = $('#results-item-total-converted-rev-daily')
    @resultsTotalConvertedRevMonth = $('#results-item-total-converted-rev-monthly')
    @resultsTotalConvertedRevAnnual = $('#results-item-total-converted-rev-annually')    

    @improveSearchNoTitleInc = $('#improved-search-no-title-increase')
    @improveSearchNoTitleIncNewSearches = $('#improved-search-no-title-increase-new-searches')
    @improveSearchNoTitleIncSuccess = $('#improved-search-no-title-increase-successful')
    @improveSearchNoTitleIncClicks = $('#improved-search-no-title-increase-new-clicks')
    @improveSearchNoTitleIncRevDay = $('#improved-search-no-title-increase-rev-daily')
    @improveSearchNoTitleIncRevMonth = $('#improved-search-no-title-increase-rev-monthly')
    @improveSearchNoTitleIncRevAnnual = $('#improved-search-no-title-increase-rev-annually')

    @improveSearchInc = $('#improved-search-increase')
    @improveSearchIncNewSearches = $('#improved-search-increase-new-searches')
    @improveSearchIncSuccess = $('#improved-search-increase-successful')
    @improveSearchIncClicks = $('#improved-search-increase-new-clicks')
    @improveSearchIncRevDay = $('#improved-search-increase-rev-daily')
    @improveSearchIncRevMonth = $('#improved-search-increase-rev-monthly')
    @improveSearchIncRevAnnual = $('#improved-search-increase-rev-annually')

    @improveSearchTotal = $('#improved-search-total')
    @improveSearchTotalRevDay = $('#improved-search-total-rev-daily')
    @improveSearchTotalRevMonth = $('#improved-search-total-rev-monthly')
    @improveSearchTotalRevAnnual = $('#improved-search-total-rev-annually')

    @totalRevMonth = $('#total-rev-monthly')
    @totalRevAnnual = $('#total-rev-annually')

    
  load: () ->
#No Right Column
    $('#promotion').remove()
    $('#main').removeClass().addClass('xs-col-12')
    $('[data-toggle="popover"]').popover()

  register: () ->

    this.load()

    @searchQueriesByDay.val(10000)
    @searchQueriesNoResults.val(20)
    @searchQueriesWithPurchase.val(10)
    @aveSpendPerItem.val(5.00)
    
    @noResultsNotInCat.val(25)
    @noResultsNotInCatConverted.val(25)

    @noResultsMisspelled.val(75)
    @noResultsMisspelledConverted.val(50)

    @resultsItemNearTop.val(80)
    @resultsItemInList.val(15)
    @resultsUserGivesUpConverted.val(75)

    @improveSearchNoTitleInc.val(1)
    @improveSearchInc.val(2)

    _this = this
    
    events = 
      "blur":->
        _this.recalculate()
    
    $('.inputtype-user').on events
    this.recalculate()

  recalculate: () ->

    _curr = '$'

    #Check all the user input fields make sense
    if isNaN(@searchQueriesByDay.val()) or @searchQueriesByDay.val() < 1
      @searchQueriesByDay.val(10000)
    
    if isNaN(@searchQueriesNoResults.val()) or @searchQueriesNoResults.val() < 1 or @searchQueriesNoResults.val() > 100
      @searchQueriesNoResults.val(20)

    @searchQueriesWithResults.val(100 - @searchQueriesNoResults.val())

    if isNaN(@searchQueriesWithPurchase.val()) or @searchQueriesWithPurchase.val() < 1 or @searchQueriesWithPurchase.val() > 100
      @searchQueriesWithPurchase.val(10)

    if isNaN(@aveSpendPerItem.val()) or @aveSpendPerItem.val() < 0.01
      @aveSpendPerItem.val(5.00)
    
    if isNaN(@noResultsNotInCat.val()) or @noResultsNotInCat.val() < 1 or @noResultsNotInCat.val() > 100
      @noResultsNotInCat.val(25)
    
    if isNaN(@noResultsNotInCatConverted.val()) or @noResultsNotInCatConverted.val() < 1 or @noResultsNotInCatConverted.val() > 100
      @noResultsNotInCatConverted.val(25)

    if isNaN(@noResultsMisspelled.val()) or @noResultsMisspelled.val() < 1 or @noResultsMisspelled.val() > 100
      @noResultsMisspelled.val(75)

    if isNaN(@noResultsMisspelledConverted.val()) or @noResultsMisspelledConverted.val() < 1 or @noResultsMisspelledConverted.val() > 100
      @noResultsMisspelledConverted.val(50)
    
    if isNaN(@resultsItemNearTop.val()) or @resultsItemNearTop.val() < 1 or @resultsItemNearTop.val() > 100
      @resultsItemNearTop.val(80)
    
    if isNaN(@resultsItemInList.val()) or @resultsItemInList.val() < 1 or @resultsItemInList.val() > 100
      @resultsItemInList.val(15)
    
    if parseFloat(@resultsItemNearTop.val()) + parseFloat(@resultsItemInList.val()) > 100
      @resultsItemInList.val(100-@resultsItemNearTop.val())

    @resultsUserGivesUp.val(100-parseFloat(@resultsItemNearTop.val()) - parseFloat(@resultsItemInList.val()))

    if isNaN(@resultsUserGivesUpConverted.val()) or @resultsUserGivesUpConverted.val() < 1 or @resultsUserGivesUpConverted.val() > 100
      @resultsUserGivesUpConverted.val(75)
    
    if isNaN(@improveSearchNoTitleInc.val()) or @improveSearchNoTitleInc.val() < 0.01 or @improveSearchNoTitleInc.val() > 100
      @improveSearchNoTitleInc.val(1)

    if isNaN(@improveSearchInc.val()) or @improveSearchInc.val() < 0.01 or @improveSearchInc.val() > 100
      @improveSearchInc.val(2)
    
    _totalSearchQueries = parseFloat(@searchQueriesByDay.val())
    _aveSpendPerItem = parseFloat(@aveSpendPerItem.val())
    _percentPurchase = parseFloat(@searchQueriesWithPurchase.val()) /100

    _percentNoResults = parseFloat(@searchQueriesNoResults.val()) / 100
    _percentResultsFound = parseFloat(@searchQueriesWithResults.val()) / 100

    _percentNotInCat = parseFloat(@noResultsNotInCat.val()) /100

    #Now do the calculations
    @noResultsNotInCatMissed.val(_totalSearchQueries * _percentNoResults * _percentNotInCat)
    @noResultsNotInCatConvertedClicks.val( Math.round(parseFloat(@noResultsNotInCatMissed.val()) * parseFloat(@noResultsNotInCatConverted.val() / 100) ))
    @noResultsNotInCatConvertedRevDay.val(_curr + Math.round(parseInt(@noResultsNotInCatConvertedClicks.val().replace(',','').replace(_curr,'')) * _aveSpendPerItem * _percentPurchase) .toMoney(0))
    @noResultsNotInCatConvertedRevAnnual.val(_curr + Math.round(parseInt(@noResultsNotInCatConvertedClicks.val().replace(',','').replace(_curr,'')) * _aveSpendPerItem * _percentPurchase * 365).toMoney(0))
    @noResultsNotInCatConvertedRevMonth.val(_curr +  Math.round(parseInt(@noResultsNotInCatConvertedRevAnnual.val().replace(',','').replace(_curr,'')) / 12).toMoney(0))

    _percentMisspelled = parseFloat(@noResultsMisspelled.val()) /100
    #Now do the calculations
    @noResultsMisspelledMissed.val(_totalSearchQueries * _percentNoResults * _percentMisspelled)
    @noResultsMisspelledConvertedClicks.val( Math.round(parseFloat(@noResultsMisspelledMissed.val()) * parseFloat(@noResultsMisspelledConverted.val() / 100) ))
    @noResultsMisspelledConvertedRevDay.val(_curr + (Math.round(parseInt(@noResultsMisspelledConvertedClicks.val().replace(',','').replace(_curr,'')) * _aveSpendPerItem * _percentPurchase) ).toMoney(0))
    @noResultsMisspelledConvertedAnnual.val(_curr + (Math.round(parseInt(@noResultsMisspelledConvertedClicks.val().replace(',','').replace(_curr,'')) * _aveSpendPerItem * _percentPurchase * 365) ).toMoney(0))
    @noResultsMisspelledConvertedMonth.val(_curr + (Math.round(parseInt(@noResultsMisspelledConvertedAnnual.val().replace(',','').replace(_curr,'')) / 12) ).toMoney(0))

    @noResultsTotal.val(100)
    @noResultsTotalMissed.val(parseInt(@noResultsNotInCatMissed.val()) + parseInt(@noResultsMisspelledMissed.val()))
    @noResultsTotalConvertedClicks.val(parseInt(@noResultsNotInCatConvertedClicks.val()) + parseInt(@noResultsMisspelledConvertedClicks.val()))
    @noResultsTotalContvertedRevDay.val(_curr + (parseInt(@noResultsNotInCatConvertedRevDay.val().replace(',','').replace(_curr,'')) + parseInt(@noResultsMisspelledConvertedRevDay.val().replace(',','').replace(_curr,''))).toMoney(0))
    @noResultsTotalConvertedRevMonth.val(_curr + (parseInt(@noResultsNotInCatConvertedRevMonth.val().replace(',','').replace(_curr,'')) + parseInt(@noResultsMisspelledConvertedMonth.val().replace(',','').replace(_curr,''))).toMoney(0))
    @noResultsTotalConvertedRevAnnual.val(_curr + (parseInt(@noResultsNotInCatConvertedRevAnnual.val().replace(',','').replace(_curr,'')) + parseInt(@noResultsMisspelledConvertedAnnual.val().replace(',','').replace(_curr,''))).toMoney(0))

    @resultsUserGivesUpMissed.val(Math.round(_totalSearchQueries * _percentResultsFound * parseFloat(@resultsUserGivesUp.val()) / 100))
    @resultsUserGivesUpConvertedClicks.val( Math.round(parseFloat(@resultsUserGivesUpMissed.val()) * parseFloat(@resultsUserGivesUpConverted.val()) / 100))
    @resultsUserGivesUpConvertedRevDay.val(_curr + (Math.round(@resultsUserGivesUpConvertedClicks.val() * _aveSpendPerItem * _percentPurchase) ).toMoney(0))
    @resultsUserGivesUpConvertedRevAnnual.val(_curr + (Math.round(@resultsUserGivesUpConvertedClicks.val() * _aveSpendPerItem * _percentPurchase * 365) ).toMoney(0))
    @resultsUserGivesUpConvertedRevMonth.val(_curr + (parseInt(Math.round(@resultsUserGivesUpConvertedRevAnnual.val().replace(',','').replace(_curr,'')) / 12) ).toMoney(0))

    @resultsTotal.val(100)
    @resultsTotalConvertedClicks.val(@resultsUserGivesUpConvertedClicks.val())
    @resultsTotalConvertedRevDay.val(@resultsUserGivesUpConvertedRevDay.val())
    @resultsTotalConvertedRevMonth.val(@resultsUserGivesUpConvertedRevMonth.val())
    @resultsTotalConvertedRevAnnual.val(@resultsUserGivesUpConvertedRevAnnual.val())

    _percentNoTitleSearchInc = parseFloat(@improveSearchNoTitleInc.val()) / 100

    @improveSearchNoTitleIncNewSearches.val( Math.round(_totalSearchQueries * _percentNoTitleSearchInc) )
    @improveSearchNoTitleIncSuccess.val(  Math.round((_percentNoResults * ( parseInt(@noResultsTotalConvertedClicks.val()) /  parseInt(@noResultsTotalMissed.val()) ) + _percentResultsFound) *1000  )/10)
    @improveSearchNoTitleIncClicks.val (Math.round(parseFloat(@improveSearchNoTitleIncNewSearches.val()) * parseFloat(@improveSearchNoTitleIncSuccess.val()) / 100))
    @improveSearchNoTitleIncRevDay.val (_curr + (Math.round( _percentPurchase * parseFloat(@improveSearchNoTitleIncClicks.val()) * _aveSpendPerItem )).toMoney(0) )
    @improveSearchNoTitleIncRevAnnual.val(_curr + (Math.round( _percentPurchase * parseFloat(@improveSearchNoTitleIncClicks.val()) * _aveSpendPerItem * 365 )).toMoney(0) )
    @improveSearchNoTitleIncRevMonth.val(_curr + (Math.round(parseInt(@improveSearchNoTitleIncRevAnnual.val().replace(',','').replace(_curr,'')) / 12) ).toMoney(0) )
    
        
    _percentSearchInc = parseFloat(@improveSearchInc.val()) / 100

    @improveSearchIncNewSearches.val( Math.round(_totalSearchQueries * _percentSearchInc) )
    @improveSearchIncSuccess.val(  Math.round((_percentNoResults * ( parseInt(@noResultsTotalConvertedClicks.val()) /  parseInt(@noResultsTotalMissed.val()) ) + _percentResultsFound) *1000  )/10)
    @improveSearchIncClicks.val (Math.round(parseFloat(@improveSearchIncNewSearches.val()) * parseFloat(@improveSearchIncSuccess.val()) / 100))
    @improveSearchIncRevDay.val (_curr + (Math.round( _percentPurchase * parseFloat(@improveSearchIncClicks.val()) * _aveSpendPerItem )).toMoney(0) )
    @improveSearchIncRevAnnual.val(_curr + (Math.round( _percentPurchase * parseFloat(@improveSearchIncClicks.val()) * _aveSpendPerItem * 365 )).toMoney(0) )
    @improveSearchIncRevMonth.val(_curr + (Math.round(parseInt(@improveSearchIncRevAnnual.val().replace(',','').replace(_curr,'')) / 12)).toMoney(0) )
    
    @improveSearchTotal.val((_percentNoTitleSearchInc + _percentSearchInc) * 100)
    @improveSearchTotalRevDay.val(_curr +  (parseInt(@improveSearchNoTitleIncRevDay.val().replace(',','').replace(_curr,'')) + parseInt(@improveSearchIncRevDay.val().replace(',','').replace(_curr,''))).toMoney(0) )
    @improveSearchTotalRevMonth.val(_curr +  (parseInt(@improveSearchNoTitleIncRevMonth.val().replace(',','').replace(_curr,'')) + parseInt(@improveSearchIncRevMonth.val().replace(',','').replace(_curr,''))).toMoney(0) )
    @improveSearchTotalRevAnnual.val(_curr +  (parseInt(@improveSearchNoTitleIncRevAnnual.val().replace(',','').replace(_curr,'')) + parseInt(@improveSearchIncRevAnnual.val().replace(',','').replace(_curr,''))).toMoney(0) )

    @totalRevMonth.val(_curr + (parseInt(@noResultsTotalConvertedRevMonth.val().replace(',','').replace(_curr,'')) +  parseInt(@resultsTotalConvertedRevMonth.val().replace(',','').replace(_curr,'')) + parseInt(@improveSearchTotalRevMonth.val().replace(',','').replace(_curr,''))).toMoney(0) )
    @totalRevAnnual.val(_curr +  (parseInt(@noResultsTotalConvertedRevAnnual.val().replace(',','').replace(_curr,'')) +  parseInt(@resultsTotalConvertedRevAnnual.val().replace(',','').replace(_curr,'')) + parseInt(@improveSearchTotalRevAnnual.val().replace(',','').replace(_curr,''))).toMoney(0) )

###

###
Number.prototype.toMoney = (decimal=2) -> @toFixed(decimal).replace /(\d)(?=(\d{3})+(?:\.\d+)?$)/g, "$1,"

###


###
class VP50GridInfoPanel 
  constructor: (target) ->
    @target = target
  
  template: (item) ->
    t = "
        <div id=\"info-panel\" data-id=\"" + item.id + "\">"


    t += item.content
            
    t += "<div id=\"close-button\" class=\"nav-button\"><span class=\"fa fa-times\"></span></div>"

    if item.nextid != -1
      t += "<div id=\"nav-next\" class=\"nav-button\" data-nextid=\""+item.nextid+"\"><span class=\"fa fa-angle-right\"></span></div>"
    
    if item.previd != -1
      t += "<div id=\"nav-previous\" class=\"nav-button\" data-previd=\""+item.previd+"\"><span class=\"fa fa-angle-left\"></span></div>"

    t += "<div id=\"info-panel-border\"></div> 
    </div>
    "

  render: (item) ->
    @target.after this.template(item)

    _this = this

    $('#info-panel #close-button').click ->
      
      _this.close()
      location.hash = 'topof_' + $('#vp50-grid li[data-id="' + item.id + '"]').prop('id')
      vpgrid.unprepare()

    $('#info-panel #nav-next').click ->
      nextid = $(this).data('nextid')
      next = $('#vp50-grid li[data-id="' + nextid + '"]')
      nextindex = $('#vp50-grid li').index($(next))
      vpgrid.prepare(nextid)
      vpgrid.show(nextid,nextindex)

    $('#info-panel #nav-previous').click ->
      previd = $(this).data('previd')
      prev = $('#vp50-grid li[data-id="' + previd + '"]')
      previndex = $('#vp50-grid li').index($(prev))
      vpgrid.prepare(previd)
      vpgrid.show(previd,previndex)

  close: () ->
    if $('#info-panel').length > 0
      $('#info-panel').remove()

###

###
class VP50Grid

  constructor: (grid) ->
    @grid = grid
    @screen = new Screen()
    @numPerRow = 4
    @panel

  register: () ->
    this.load()
    $(window).on 'deviceWidthChange', =>
     this.redraw()


  unprepare: () ->
    @grid.find('li.cell').each (i, el) ->
        $(el).removeClass('expanded')
        $(el).removeClass('deselected')

  prepare: (id) ->
    @grid.find('li.cell').each (i, el) ->
      if $(el).data('id') != id 
        $(el).removeClass('expanded')
        $(el).addClass('deselected')
      else
        $(el).addClass('expanded')
        $(el).removeClass('deselected')


  show: (id, currentIndex) ->
    # If the panel is already visible, hide it

    load = true
    _existingPanelId = -1

    if $('#info-panel').length > 0
      if($('#info-panel').data('id') isnt id)
        _existingPanelId = $('#info-panel').data('id')
        @panel.close()
        load = true
      else 
        load = false
    
    if load

      if @screen.screenSize is 'lg' 
        @numPerRow = 5
      else if @screen.screenSize is 'md'
        @numPerRow = 4
      else if @screen.screenSize is 'sm'
        @numPerRow = 3
      else 
        @numPerRow = 2

      # find the next row end
      _rem = ((currentIndex+1) % @numPerRow) 

      _target = $('#vp50-grid li[data-id="' + id + '"]')
      _content = $(_target).find('.cell-info-panel').html()

      _nextid = -1
      if $(_target).next().length > 0
        _nextid = $(_target).next().data('id')

      _previd = -1
      if $(_target).prev().length > 0
        _previd = $(_target).prev().data('id')


      if _rem > 0
        for i in [1..@numPerRow - _rem] by 1
          try
            if $(_target).next().length > 0
              _target = $(_target).next() 
          catch e
            # Funny number at the end of a row
   
      @panel = new VP50GridInfoPanel($(_target))
      
      @panel.render({ 
        "id":id,
        "nextid":_nextid,
        "previd":_previd,
        "content": _content
      })
      
      #if _existingPanelId isnt -1
      #  _existingPanelRow = $('#vp50-grid li[data-id="' + _existingPanelId + '"]').data('row')
      #  _newPanelRow = $('#vp50-grid li[data-id="' + id + '"]').data('row')
      #  if _existingPanelRow isnt _newPanelRow
      location.hash = 'jumpto_' + $('#vp50-grid li[data-id="' + id + '"]').prop('id')
          

  load: () ->
    _grid = @grid
    _screen = @screen
    $this = this

    #No Right Column
    $('#promotion').remove()
    $('#main').removeClass().addClass('xs-col-12')



    # Set the scroll event on the ads
    $(window).scroll ->
      $this.showHideAds()

    this.redraw()

    cells = _grid.find('li.cell')
    cells.each (index, e) =>  
      $(e).mouseenter () ->
        $(this).find('img').removeClass('desaturate')

      $(e).mouseleave () ->
        $(this).find('img').addClass('desaturate')

      $(e).click () ->
        _id = $(this).data('id');
        _index = $('#vp50-grid li').index($(this))
        $this.prepare(_id)
        $this.show(_id, _index)
        showHideAds()
        

  showHideAds: () ->
    _screen = @screen
    _grid = @grid

    $ads = $('#vp50-ads')
    $gridfoot = $('#vp50-foot')

    gridInView = _screen.isScrolledIntoView($(_grid), false)
    gridfootInView = _screen.isScrolledIntoView($gridfoot ,false)
    if gridInView or gridfootInView
      $ads.addClass('on-screen')
      if !gridfootInView
        $ads.removeClass('inline').addClass('floating')
      else
        $ads.addClass('inline').removeClass('floating')
    else
      $ads.removeClass('on-screen').removeClass('floating').removeClass('inline')


  redraw: () ->
    _grid = @grid

    if @screen.screenSize is 'lg'
      @numPerRow = 5
    else if @screen.screenSize is 'md'
      @numPerRow = 4
    else if @screen.screenSize is 'sm'
      @numPerRow = 3
    else 
      @numPerRow = 2

    _currentRow = 0
    _numPerRow = @numPerRow

    _grid.find('li.cell').each (i, el) ->
      $(el).removeClass('expanded')
      $(el).removeClass('deselected')
      
      if  i >= (_currentRow * _numPerRow) + _numPerRow
        _currentRow++
      $(el).data('row',_currentRow)

    if @panel
      @panel.close()
###


###
class Screen

  constructor: () ->
    @screenSize = 'xs'
    this.detectDeviceWidthChange()
    $s = this
    $(window).resize () ->
      $s.detectDeviceWidthChange()

  detectDeviceWidthChange: () ->
    width = $(window).width()

    if width < 768
      dw = 'xs'
    else if width < 992
      dw = 'sm'
    else if width < 1200
      dw = 'md'
    else
      dw = 'lg'
    

    if(dw != @screenSize)
      @screenSize = dw
      $(window).trigger('deviceWidthChange', [@screenSize])

   
   isScrolledIntoView: (elem, requireEntirelyVisible) ->
    $elem = $(elem)
    $window = $(window)
    docViewTop = $window.scrollTop()
    docViewBottom = docViewTop + $window.height()
    elemTop = $elem.offset().top
    elemBottom = elemTop + $elem.height()
    if(!requireEntirelyVisible)
      return ((( elemTop >= docViewTop) && (elemTop <= docViewBottom)) ||  ((elemTop <= docViewTop && elemBottom >= docViewBottom)) || ((elemBottom >= docViewTop) && (elemBottom <= docViewBottom))) 
    else
      return ((elemBottom <= docViewBottom) && (elemTop >= docViewTop))


###

###
class VUIDailySnapshot

  register: () ->
    _load = this.load
    _load()
    
  load: ->
    data = { "a":"dailysnap" }
    jqXHR = $.getJSON("/vui/vui-xml-actions", data)
    jqXHR.done (json) ->
      snap = json.data.DailySnapshot
      payModel = snap.PayModel
      if payModel != ''
        payModel = payModel.replace(/,/g,', ')
      category = snap.Category
      if category != ''
        category = category.replace(/,/g,', ')
      
      template = $('#vui-service-sheet-template').clone()
      template
        .find('article header h1').text(snap.ServiceName).end()
        .find('article header .intro .b-info')
            .find('img').attr('src',snap.IconURL).end()
            .find('table tr td[data-name="availability"]').text(snap.Availability).end()
            .find('table tr td[data-name="pay-model"]').text(payModel).end()
            .find('table tr td[data-name="category"]').text(category).end()
            .end()
            
      if snap.Snapshot.numScreenshots > 0
        template.find('article .b-stats .inner li[data-name="screenshots"]')
          .find('span.data-point').text(snap.Snapshot.numScreenshots).end()
          .find('span.num-devices').text(snap.Snapshot.numScreenshotDevices).end()
      else
        template.remove('article .b-stats .inner li[data-name="screenshots"]').remove()
        
      if snap.Snapshot.benchmarkAverage > 0
        template.find('article .b-stats .inner li[data-name="benchmark"]')
            .find('span.data-point').text(snap.Snapshot.benchmarkAverage).end()
      else
        template.find('article .b-stats .inner li[data-name="benchmark"]').remove()
        
      if snap.Snapshot.ratingAverage > 0
        template.find('article .b-stats .inner li[data-name="rating"]')
            .find('span.data-point').text(snap.Snapshot.ratingAverage).end()
      else
        template.find('article .b-stats .inner li[data-name="rating"]').remove()
        
      if snap.Snapshot.twitterFollowers > 0
        template.find('article .b-stats .inner li[data-name="twitter"]')
            .find('span.data-point').text(numberWithCommas(snap.Snapshot.twitterFollowers)).end()
      else
        template.find('article .b-stats .inner li[data-name="twitter"]').remove()
        
      if snap.Snapshot.facebookLikes > 0
        template.find('article .b-stats .inner li[data-name="facebook"]')
            .find('span.data-point').text(numberWithCommas(snap.Snapshot.facebookLikes)).end()
      else
        template.find('article .b-stats .inner li[data-name="facebook"]').remove()
        
      if snap.Snapshot.ytSubscriberCount > 0
        template.find('article .b-stats .inner li[data-name="youtube"]')
            .find('span.data-point').text(numberWithCommas(snap.Snapshot.ytSubscriberCount)).end()
      else
        template.find('article .b-stats .inner li[data-name="youtube"]').remove()
        
      
      if snap.Screenshots.resultCount > 0        
        for screenshot in snap.Screenshots.screenshots
          screenshotTemplate = template.find('#vui-service-screenshot-template').clone()
          screenshotTemplate
            .find('.name').text(screenshot.PageType).end()
            .find('.device').text(screenshot.Device).end()
            .find('.img a').attr('href',screenshot.ImageURL_lg).attr('data-lightbox','vui-images').end()
            .find('.img img').attr('src',screenshot.ImageURL_th).end()
          .end()
          template.find('article .b-screenshots .carousel ul').append(screenshotTemplate.find('li'))

      template.find('#vui-service-screenshot-template').remove()        
      $('#vui-service-sheet .loading').hide()
      template.find('article').appendTo('#vui-service-sheet')
      w = $('#vui-service-sheet article .b-screenshots .carousel ul li').first().outerWidth(true)  
      n = $('#vui-service-sheet article .b-screenshots .carousel ul li').length
      pad = parseInt($('#vui-service-sheet article .b-screenshots .carousel ul').css('padding-left').replace('px','')) + parseInt($('#vui-service-sheet article .b-screenshots .carousel ul').css('padding-right').replace('px',''))
      ulw = (w * n) + pad
      $('#vui-service-sheet article .b-screenshots .carousel ul').css('width', ulw + 'px')
      $('#vui-service-sheet article .b-screenshots .carousel').jCarouselLite({
            circular: true,
            auto: false,
            timeout: 2500,
            speed: 500,
            btnNext: "#vui-service-sheet article .b-screenshots .lightbox-next",
            btnPrev: "#vui-service-sheet article .b-screenshots .lightbox-prev",
            swipe: true;
        })
      return true
###

###
bindEnter = (panel, button) ->
  panel.keyup (event) ->
    code = event.which;
    if code is 13
      button.trigger("click");
      event.preventDefault();
###

###
numberWithCommas = (x) ->
  x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
###


###
$(document).ready () ->

  if $('#vp2-regwall').length > 0
    regwall = new RegWall()
    regwall.register() 

  if $("#inner-full").length > 0
    newsLoader = new NewsLoader(300)
    newsLoader.register()
#  if $("#inner-left").length > 0
#    newsFeedLoader = new NewsFeedLoader(500)
#    newsFeedLoader.register()
#  if $("#inner-center").length > 0
#    newsArticleLoader = new NewsArticleLoader(300)
#    newsArticleLoader.register()
  if $('#search-button').length > 0
    bindEnter($('nav .form-inline .form-group'), $("#search-button"));
    search = new Search()
    search.register()
  if $("#inner-search-results").length > 0
    searchLoader = new SearchLoader(300)
    searchLoader.register()
  if $("#inner-job-listing").length > 0
    jobsLoader = new JobsLoader(300)
    jobsLoader.register()
  if $('#rhs-register').length > 0
    rhsReg = new RHSSignup()
    rhsReg.register()

  $("#tab-news").click (e) ->
    $("#column-center").removeClass("active")
    $("#tab-featured").removeClass("active");
    $("#tab-news").addClass("active")
    $("#column-left").addClass("active")
    e.preventDefault()

  $("#tab-featured").click (e) ->
    $("#column-left").removeClass("active")
    $("#tab-news").removeClass("active");
    $("#tab-featured").addClass("active")
    $("#column-center").addClass("active")
    e.preventDefault()

  if $('.form-registration').length > 0
    $('.form-registration [type="submit"]').addClass("btn btn-lg btn-primary")
    
    if $('.form-registration span.error').length > 0
      $('.alert-warning').removeClass('hidden')
      
    if $('.orgtype').length > 0
      $('.orgtype').change (e) ->
        orgtype = $(this).val()
        if orgtype.toLowerCase() == 'other'
          $('.orgtypeother').show()
        else
          $('.orgtypeother').hide()

  if $('.article-main img').not('.vp-nolightbox').length > 0
    $('.article-main img').not('.vp-nolightbox').each (index, e) ->
      if $(e).parents('a, .vp-nolightbox').length is 0
        imgurl = $(e).attr('src')
        $(e).wrap("<a href=\"#{imgurl}\" data-lightbox=\"defaultgroup\" title=\"Open in lightbox\"></a>")
        
  if $('.article-main a.lightbox').not('.vp-nolightbox').length > 0
    $('.article-main a.lightbox').not('.vp-nolightbox').each (index, e) ->    
      $(e).removeClass('lightbox').attr('data-lightbox','defaultgroup').attr('title','Open in lightbox')
        
  if $('#vui-service-sheet').length > 0
    snap = new VUIDailySnapshot()
    snap.register()
  
  if $('#vp50-grid').length > 0
    vpgrid = new VP50Grid($('#vp50-grid'))
    vpgrid.register()

  if $('#ROICalc').length > 0
    roicalc = new ROICalculator($('#ROICalc'))
    roicalc.register()


  jQuery.easing.def = 'easeOutQuart';
 
 # $().UItoTop({ easingType: 'easeOutQuart' });
  
 # jQuery.event.special.swipe.settings = {
 #   threshold: 0.1,
 #   sensitivity: 9
 # };
 
  if $('#txtGoogleMapEmbed').length > 0 and $('#hidGoogleMapEmbed').val().length > 0 
	  $('#txtGoogleMapEmbed').val(window.unescape($('#hidGoogleMapEmbed').val()))
 
  datePickers = `
    function() {
      if($('#eventEntryForm').length > 0) {
	
		$('.datetimepicker input[type=text]').datetimepicker({defaultTime:'00:00'});
		$('.datetimepicker .input-group-addon').click(function(e){
			$(this).parent().find('input[type=text]').first().datetimepicker('show');
		});
	    // $('#txtEndDate').datetimepicker();
	  }
	  return true;
    };`
  datePickers()
  
  countchars = `
    function countChar() {
	  var text_max = 1000;
      
      $('.text-counted').keyup(function() {
        var text_length = $('.text-counted').val().length;
		if(text_length >= text_max) {
		  $('.text-counted').val($('.text-counted').val().substring(0, text_max));
		  text_length = text_max;
		}
        var text_remaining = text_max - text_length;
        $('.counter').html(text_remaining);
      });
	  
	  $('.text-counted').trigger('keyup');
	  
	  return true;
    }; `  
  countchars()
  
  return true
  