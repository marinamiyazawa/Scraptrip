require 'base64'
require 'json'
require 'net/https'
module Vision
  class << self
    def get_image_data(image_file, flag)
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_VISION_API_KEY']}"
      # 　画像をbase64にエンコード
      base64_image = Base64.encode64(open("#{Rails.root}/tmp/uploads/store/#{image_file.id}").read)
      # APIリクエスト用のJSONパラメータ
      if flag == "label"
        type = 'LABEL_DETECTION'
      else
        type = 'LANDMARK_DETECTION'
      end
      params = {
        requests: [{
          image: {
            content: base64_image,
          },
          features: [
            {
              type: type,
            },
          ],
        }],
      }.to_json
      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      if JSON.parse(response.body)['responses'][0].blank?
        return []
      end
      # APIレスポンス出力
      puts response.body

      if flag == "label"
        JSON.parse(response.body)['responses'][0]['labelAnnotations'].pluck('description', 'score').uniq
      else
        if JSON.parse(response.body)['responses'][0]['landmarkAnnotations'].first
          JSON.parse(response.body)['responses'][0]['landmarkAnnotations'].pluck('description', 'score', 'locations')
        else
          return []
        end
      end
    end

    # def self.res(response)
    # JSON.parse reponse
    # end
  end
end
