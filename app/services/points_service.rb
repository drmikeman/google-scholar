class PointsService
  def call(journal, year)
    conn = Faraday.new(url: 'https://stormy-brushlands-34577.herokuapp.com') do |f|
      f.response(:json)
      f.adapter Faraday.default_adapter
    end

    response = conn.get do |req|
      req.url '/api/points', journal: journal, year: year
    end

    response.body["points"] || 0
  end
end