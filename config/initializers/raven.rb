require 'raven'

Raven.configure do |config|
  config.dsn = 'https://26fdd637de3a4f0880a3353d601006bb:38a30776c2de41299848fc2d9d41a891@app.getsentry.com/40617'
  config.environments = %w[ production ]
end