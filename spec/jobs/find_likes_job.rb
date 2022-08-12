RSpec.describe 'Report generation test' do
  before do
    Timecop.freeze("23/06/2022")

    user = User.create(name: "tan", handle:"tan", bio: "tan", email: "tan@toptal.com", password:"123", password_confirmation: "123") 
    tweet = user.tweets.create(content: "content")
    like = tweet.likes.create(tweet_id: tweet.id, user_id: user.id)
    FindLikesJob.perform_now(user.id, "23/06/2022", "25/06/2022") 
  end

  after { Timecop.return }

  let!(:file_path) { "./likes_report.csv" }
  let!(:csv) { CSV.open(file_path, "r") }
  
  specify { expect(csv.read).to eq([
    ["23/06/2022", "1"],
    ["24/06/2022", "0"], 
    ["25/06/2022", "0"]]) }
end