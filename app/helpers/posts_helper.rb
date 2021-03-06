module PostsHelper
  def get_edit_route(comment)
    if params[:action] == "show"
      if !comment.attachments.empty? 
        if !comment.attachments.select{|a| a.image?}.empty?     
          space_post_path(comment.space, params[:id] ? params[:id] : comment.id,:edit => comment.id, :form => 'photos')
        else
          space_post_path(comment.space, params[:id] ? params[:id] : comment.id,:edit => comment.id, :form => 'docs')
        end
      else
        space_post_path(comment.space, params[:id] ? params[:id] : comment.id,:edit => comment.id)
      end
    else
      if !comment.attachments.empty? 
        if !comment.attachments.select{|a| a.image?}.empty?     
          space_posts_path(comment.space, :edit => comment.id, :form => 'photos')
        else
          space_posts_path(comment.space, :edit => comment.id, :form => 'docs')
        end
      else
        space_posts_path(comment.space, :edit => comment.id)
      end
    end
  end
  
  def get_reply_route(post,form='')
    if params[:action] == "show"
      space_post_path(post.space, params[:id],:reply_to => post.id, :form => form)
    else
      space_posts_path(post.space, :reply_to => post.id, :form => form)
    end
  end
  
  def first_words( text, size )
    return truncate(text, :lenght => size, :omision => "...")
    
    #!!!! WARNING !!!
    if text.length > size
      cutted_text = text[0..size]
      cutted_text.chop! until cutted_text[-1,1] == " "
      cutted_text.chop!
      cutted_text << "..."
    else
      text
    end
  end
  
  def thread_title(post)
    post.parent_id.nil? ? post.title : post.parent.title
  end
  
  def thread(post)
    post.parent_id.nil? ? post : post.parent
  end
  
  def post_format( text)
   text ||=""
   (text.include?("<") && text.include?("</") && text.include?(">")) ? text : simple_format(text)
  end
  
  def get_today_posts(posts)
    posts.select{|x| x.updated_at > Date.yesterday}
  end
  
  def get_yesterday_posts(posts)
    posts.select{|x| x.updated_at > Date.yesterday - 1 && x.updated_at < Date.yesterday}
  end
  
  def get_last_week_posts(posts)
    posts.select{|x| x.updated_at > Date.today - 7 && x.updated_at < Date.yesterday - 1}
  end
  
  def get_older_posts(posts)
    posts.select{|x| x.updated_at < Date.today - 7}
  end
  
  def small_post_text_area(cont="")
    text_area_tag "post[text]", cont, :class => "small_post_text"
  end
  
  #method to know if a thread or any of its comments has attachment/s
  def has_attachments(thread)
    if thread.attachments.any?
      return true
    end
    #let's look around the children
    for post in thread.children
      if post.attachments.any?
        return true
      end
    end
    return false
  end
  
  #method to get the attachment name
  def attachment_name(thread)
    if thread.attachments.any?
      return thread.attachments.first.filename
    end
    #let's look around the children
    for post in thread.children
      if post.attachments.any?
        return post.attachments.first.filename
      end
    end
    return ""
  end
end
