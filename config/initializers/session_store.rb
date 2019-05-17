
# sessionを保持する期間の設定
# 一ヶ月に設定、ログインしたら、さらに一ヶ月延長される
# このPortfolioは自分のアプリ名
Portfolio::Application.config.session_store :cookie_store, key: '_portfolio_session', expire_after: 1.month