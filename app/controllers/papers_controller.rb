class PapersController < ApplicationController
  def index
    @from = 2010
    @to = 2018

    @papers = Profile.all.
      map { |profile| papers(profile.name, @from, @to) }.
      flatten.
      map { |profile| profile.except("profile") }.
      uniq { |paper| paper["title"] }.
      map { | paper| paper.merge("points" => points(paper["journal"], paper["year"])) }.
      sort_by { |paper| paper["points"] }.
      reverse
  end

  private

  def papers(profile, from, to)
    PapersService.new.call(profile, from, to)
  end

  def points(journal, year)
    PointsService.new.call(journal, year)
  end
end
