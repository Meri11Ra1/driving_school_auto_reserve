require 'net/http'
require 'uri'
require 'json'

loop do
  # 自連のキャンセル待ちが8:30から始まるので、その時間になったら実行
  if (Time.now.hour == 8 && Time.now.min == 30 && Time.now.sec == 0) then
    File.open("data.json") do |f|
      data = JSON.load(f)
      for i in 0..1 do      
        # リクエストを送信するURL
        url = URI.parse(data["url"])

        # リクエストのパラメータを設定
        params = {
          'APPNAME' => 'YKOK',
          'PRGNAME' => 'NET_CANSELMACHI_BAT',
          'ARGUMENTS' => data["auth"]["argument"][i],
        }

        p data["auth"]["argument"][i]
        # POSTリクエストを作成
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true if url.scheme == 'https'

        request = Net::HTTP::Post.new(url.path)
        request.set_form_data(params)

        # リクエストを送信してレスポンスを取得
        response = http.request(request)
        # body_str = response.body.to_s
        # body_str = body_str.encode("UTF-8", "Shift_JIS")
      end
    end
  end
end

# レスポンスの内容を出力
puts "Response Code: #{response.code}"
puts "Response Body: #{body_str}"