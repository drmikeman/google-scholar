class PapersController < ApplicationController
  def search; end

  def index
    @from = params[:from] || 2010
    @to = params[:to] || 2018
    @profiles = params[:profiles].split(/\r\n/)

    selected_profiles = filter_profiles_by_names(@profiles)
    papers_for_each_profile = fetch_papers_for_each_profile(selected_profiles)
    papers = flatten_papers(papers_for_each_profile)
    uniq_papers = papers_with_uniqe_title(papers)
    narrow_papers = remove_profile_and_person(uniq_papers)
    papers_with_points = append_points(narrow_papers)
    sorted_papers = sort_by_points(papers_with_points)

    @papers = sorted_papers
    @score = sum_paper_points(sorted_papers)
  end

  private

  def filter_profiles_by_names(names)
    Profile.where(name: names)
  end

  def fetch_papers_for_each_profile(profiles)
    profiles.map { |profile| papers(profile.name, @from, @to) }
  end

  def flatten_papers(papers_for_each_profile)
    papers_for_each_profile.flatten
  end

  def papers_with_uniqe_title(papers)
    papers.uniq { |paper| paper["title"] }
  end

  def remove_profile_and_person(papers)
    papers.map { |paper| paper.except("profile", "person") }
  end

  def append_points(papers)
    papers.map { |paper| paper.merge("points" => points(paper["journal"], paper["year"])) }
  end

  def sort_by_points(papers)
    papers.sort_by { |paper| paper["points"] }.reverse
  end

  def sum_paper_points(papers)
    papers.sum { |paper| paper["points"] }
  end

  def papers(profile, from, to)
    PapersService.new.call(profile, from, to)
  end

  def points(journal, year)
    PointsService.new.call(journal, year)
  end
end
