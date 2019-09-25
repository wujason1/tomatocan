require 'test_helper'

class GuestVisitsHomePageTest < ActionDispatch::IntegrationTest
	setup do
    	visit root_path
	end

	test "should go to home after clicking on home" do
    within("div#globalNavbar.collapse.navbar-collapse") do
      click_on('Home', match: :first)
      assert_equal current_path, root_path
    end 
  end

  #dpc = discover previous conversations
  test "should go to dpc page when clicking on dpc in header"  do
    within("div#globalNavbar.collapse.navbar-collapse") do
      click_on("Discover Previous Conversations", match: :first)
      assert_equal current_path, supportourwork_path
    end 
  end 

  #iuts = invite us to speak
   test "should go to iuts page when clicking iuts in header"  do
    within("div#globalNavbar.collapse.navbar-collapse") do
      click_on('Invite Us To Speak', match: :first)
      assert_equal current_path, drschaeferspeaking_path
    end 
  end 

   test "should go to about page when clicking about in header"  do
    within("div#globalNavbar.collapse.navbar-collapse") do
      click_on('Remotely or in Scottsdale', match: :first)
      assert_equal current_path, internship_path
    end 
  end 

  test "should go to FAQ page when clicking on FAQ in header"  do
    within("div#globalNavbar.collapse.navbar-collapse") do
      click_on('FAQ', match: :first)
      assert_equal current_path, faq_path
    end 
  end 

  test "should go to sign up page after clicking on sign up"  do
    within("div#globalNavbar.collapse.navbar-collapse") do
      click_on('Sign Up', match: :first)
      assert_equal current_path, new_user_signup_path
    end
  end 

  test "should go to log in page after clicking on sign in"  do
    within("div#globalNavbar.collapse.navbar-collapse") do
      click_on("Sign In", match: :first)
      assert_equal current_path, new_user_session_path
    end   
  end

  test "should go to FAQ page when clicking on FAQ in footer"  do
    within("div.col-sm-2.col-sm-offset-1") do
      click_on('FAQ', match: :first)
      assert_equal current_path, faq_path
    end 
  end

  #tos = terms of service
  test "should go to tos page when clicking on tos in footer"  do
    within("div.col-sm-2.col-sm-offset-1") do
      click_on("Terms of Service", match: :first)
      assert_equal current_path, tos_path
    end 
  end  

  test "should be a link for emailing website in footer" do
    within("div#footer.row") do
      assert page.has_link?('info@ThinQ.tv')
    end
  end 

  test "images should exist for social media sharing buttons in footer" do
    email_img = "//footer/div/div/div[3]/a[3]/img"
    linkedin_img = "//footer/div/div/div[3]/a[2]/img"
    facebook_img = "//footer/div/div/div[3]/div/a/img"
    twitter_img = "//footer/div/div/div[3]/a[1]/img"

    assert page.has_xpath? email_img
    assert page.has_xpath? linkedin_img
    assert page.has_xpath? facebook_img
    assert page.has_xpath? twitter_img
  end

  test "links should exist for social media sharing buttons in footer" do
    linkedin_link = "/html/body/header/footer/div/div/div[3]/a[2]"
    facebook_link = "/html/body/header/footer/div/div/div[3]/div/a"
    twitter_link = "/html/body/header/footer/div/div/div[3]/a[1]"
    email_link = "/html/body/header/footer/div/div/div[3]/a[3]"

    assert page.has_xpath? linkedin_link
    assert page.has_xpath? facebook_link
    assert page.has_xpath? twitter_link
    assert page.has_xpath? email_link
  end

=begin
   test "should be able to host a live conversation" do
    within("div.panel.panel-default") do
      click_on("Host a Live Conversation", match: :first)
      assert_equal current_path, new_event_path
    end 
  end  
  
  test "should be able to add my own conversation" do
    within("div.row.learnMore") do
      click_on("Add Your Conversation", match: :first)
      assert_equal current_path, new_event_path
    end 
  end  
=end

end
