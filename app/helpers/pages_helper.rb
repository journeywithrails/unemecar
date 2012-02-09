module PagesHelper
  def add_links_to_tweet(tweet)
    #tweet = "wow blah blah blah @pedm this link is really cool http://google.com just like this https://web.com"
    twitter_collect = ""
    tweet.split(" ").each{ |word|
      if word.starts_with?("@") and word.length != 1
        if word[word.length-1..word.length] == ":"
          puts "test " + word 
          twitter_collect << '<a href="http://twitter.com/' << word[1..word.length-2] << '" target="_blank">' << word << "</a>"
        else
          twitter_collect << '<a href="http://twitter.com/' << word[1..word.length] << '" target="_blank">' << word << "</a>"
        end
      elsif word.starts_with?("http://") or word.starts_with?("https://")
        twitter_collect << '<a href="' << word << '" target="_blank">' << word << "</a>"
      else
        twitter_collect << word
      end
      twitter_collect << " "
    }
    return twitter_collect.capitalize
  end
  
end
