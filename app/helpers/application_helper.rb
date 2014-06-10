module ApplicationHelper
  def app_name
    "Underflow"
  end

  def body_class
    "#{controller_name} #{action_name}"
  end

  def created_ago(object)
    unless object.created_at.blank?
      time_ago_in_words(object.created_at) + " #{t('time.ago')}"
    end
  end

  def time_distance_ago(time_from)
    unless time_from.blank?
      distance_of_time_in_words_to_now(time_from) + " #{t('time.ago')}"
    end
  end

  def tr(model, action, gender='male')
    { notice: tr_raw(model, action, gender) }
  end

  def tr_raw(model, action, gender='male')
    t("model.#{gender}.#{action}",
      model: t("activerecord.models.#{model}", count: 1))
  end

  def item_class(item)
    "own" if user_signed_in? && current_user == item.user
  end

  def class_with_id(object)
    "##{object.class.to_s.underscore}-#{object.id}"
  end

  def accept_link_class(question, answer)
    link_class = 'accept'
    link_class += ' hidden' if other_than_accepted_answer(question, answer)
    link_class += ' accepted' if question.accepted?(answer)
    link_class
  end

  def other_than_accepted_answer(question, answer)
    !question.accepted?(answer) && question.accepted_answer
  end

  def add_to_favorites_link(object, &blk)
    link_to [:favor, object], remote: true, data: {type: 'json'},
      class: favor_class(object), title: object.favored_by?(current_user) ?
        t('favorite.favored') : t('favorite.favor') do
          blk.call
    end
  end

  def favor_class(object)
    klass = 'favor glyphicon glyphicon-star'
    klass += ' favored' if current_user && current_user.favorite(object)
    klass
  end

  def link_to_vote_for(object, vote, &blk)
    link_to [object, :"vote_#{vote}"], method: 'post', remote: true,
      data: {type: 'json'}, class: vote_class(object, vote),
      title: vote_text(object, vote) do
        blk.call
    end
  end

  def vote_class(object, vote)
    klass = "#{vote}vote glyphicon glyphicon-chevron-#{vote}"
    klass += ' voted' if current_user && vote == current_user.voted(object)
    klass
  end

  def vote_text(object, vote)
    current_user && current_user.voted(object) == vote ?
      t("vote.#{vote}voted") :
      t("vote.#{vote}")
  end

  def cp(path)
    current_page?(path) ? " active" : ''
  end

  def questions_with_scope_path
    params[:scope] ? "/questions/#{params[:scope]}" : '/questions'
  end

  # Kaminari override
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

  # Override Rails helper
  def current_page?(options)
    unless request
      raise "You cannot use helpers that need to determine the current " \
            "page unless your view context provides a Request object " \
            "in a #request method"
    end

    return false unless request.get? || request.head?

    url_string = URI.parser.unescape(url_for(options)).force_encoding(Encoding::BINARY)


    # We ignore any extra parameters in the request_uri if the
    # submitted url doesn't have any either. This lets the function
    # work with things like ?order=asc
    request_uri = url_string.index("?") ? request.fullpath : request.path
    request_uri = URI.parser.unescape(request_uri).force_encoding(Encoding::BINARY)


    # Remove pagination parts from url
    request_uri_copy = request_uri.sub(/\/page\/\d+/, '')

    if url_string =~ /^\w+:\/\//
      url_string == "#{request.protocol}#{request.host_with_port}#{request_uri_copy}"
    else
      url_string == request_uri_copy
    end
  end
end
