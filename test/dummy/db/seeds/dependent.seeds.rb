after :dependency do
  Post.create(:title => 'title')
end