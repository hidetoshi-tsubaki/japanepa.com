# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.

# Rails.application.config.assetøs.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += %w( quiz.js )
Rails.application.config.assets.precompile += %w( show_charts.js )
Rails.application.config.assets.precompile += %w( common.js )
Rails.application.config.assets.precompile += %w( prev_img.js )
Rails.application.config.assets.precompile += %w( infinite_scroll.js )
Rails.application.config.assets.precompile += %w( indexCharts.js )
Rails.application.config.assets.precompile += %w( calendar.js )
Rails.application.config.assets.precompile += %w( summernote-bs4.min.js )
Rails.application.config.assets.precompile += %w( summernote.js )
Rails.application.config.assets.precompile += %w( community.js )
Rails.application.config.assets.precompile += %w( score_record.js )
Rails.application.config.assets.precompile += %w( counting_chart.js )

# Rails.application.config.assets.precompile += %w( admin.js admin.css )

