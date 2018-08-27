class PapersController < ApplicationController
  def search; end

  def index
    @from = params[:from] || 2010
    @to = params[:to] || 2018
    @profiles = params[:profiles].split(/\r\n/)

    @papers = Profile.
      where(name: @profiles).
      map { |profile| papers(profile.name, @from, @to) }.
      flatten.
      map { |paper| paper.except("profile", "person") }.
      uniq { |paper| paper["title"] }.
      map { |paper| paper.merge("points" => points(paper["journal"], paper["year"])) }.
      sort_by { |paper| paper["points"] }.
      reverse

    @score = @papers.sum { |paper| paper["points"] }
  end

  private

  def papers(profile, from, to)
    PapersService.new.call(profile, from, to)
  end

  def points(journal, year)
    PointsService.new.call(journal, year)
  end
end
