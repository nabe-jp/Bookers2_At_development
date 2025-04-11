class HomesController < ApplicationController
  def top
    # このページでは検索機能を表示しないようにするため
    @no_layouts_search = true
  end

  def about
  end
end