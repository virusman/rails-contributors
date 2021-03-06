class ApplicationController < ActionController::Base
  before_filter :trace_user_agent

private
  def set_contributor
    @contributor = Contributor.find_by_param(params[:contributor_id])
    head :not_found unless @contributor
  end

  def set_release
    @release = Release.find_by_param(params[:release_id])
    head :not_found unless @release
  end

  def set_time_constraints
    @time_window = params[:time_window].presence || 'all-time'
    if TimeConstraints.known_key?(@time_window)
      @since = TimeConstraints.since_for(@time_window)
    else
      head :not_found
    end
  end

  BOTS_REGEXP = %r{
    Baidu         |
    Gigabot       |
    Openbot       |
    Google        |
    libwww-perl   |
    lwp-trivial   |
    msnbot        |
    SiteUptime    |
    Slurp         |
    WordPress     |
    ZIBB          |
    ZyBorg        |
    Yahoo         |
    Lycos_Spider  |
    Infoseek      |
    ia_archiver   |
    scoutjet      |
    nutch         |
    nuhk          |
    dts\ agent    |
    twiceler      |
    ask\ jeeves   |
    Webspider     |
    Daumoa        |
    MEGAUPLOAD    |
    Yammybot      |
    yacybot       |
    GingerCrawler |
    Yandex        |
    Gaisbot       |
    TweetmemeBot  |
    HttpClient    |
    DotBot        |
    80legs        |
    MLBot         |
    wasitup       |
    ichiro        |
    discobot      |
    bingbot       |
    yrspider
  }xi
  def trace_user_agent
    if request.user_agent =~ BOTS_REGEXP
      logger.info("(BOT) #{request.user_agent}")
    else
      logger.info("(BROWSER) #{request.user_agent}")
    end
  end
end
