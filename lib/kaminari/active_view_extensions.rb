module Kaminari
  module ActionViewExtension

    # def page_entries_info(collection, options = {})
    #   entry_name = options[:entry_name] || collection.entry_name
    #   entry_name = entry_name.pluralize unless collection.total_count == 1

    #   if collection.total_pages < 2
    #     t('helpers.page_entries_info.one_page.display_entries', :entry_name => entry_name, :count => collection.total_count)
    #   else
    #     first = collection.offset_value + 1
    #     last = collection.last_page? ? collection.total_count : collection.offset_value + collection.limit_value
    #     t('helpers.page_entries_info.more_pages.display_entries', :entry_name => entry_name, :first => first, :last => last, :total => collection.total_count)
    #   end.html_safe
    # end

    def page_entries_info(collection, options = {})
      entry_name = options[:entry_name] || collection.model_name.to_s.downcase
      if collection.total_pages < 2
        entry_name = t("activerecord.models.#{entry_name}", count: collection.total_count)
        t('helpers.page_entries_info.one_page.display_entries',
          entry_name: entry_name, count: collection.total_count)
      else
        entry_name = t("activerecord.models.#{entry_name}.other")
        first = collection.offset_value + 1
        last = collection.last_page? ?
          collection.total_count :
          collection.offset_value + collection.limit_value
        t('helpers.page_entries_info.more_pages.display_entries',
          entry_name: entry_name, first: first, last: last,
          total: collection.total_count)
      end.html_safe
    end
  end
end