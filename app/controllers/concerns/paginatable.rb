module Paginatable
  extend ActiveSupport::Concern

  included do
    def paginate(collection)
      collection.page(params[:page]).per(params[:per_page] || 10)
    end

    def pagination_meta(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    end
  end
end
