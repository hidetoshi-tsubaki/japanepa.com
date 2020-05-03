FactoryBot.define do
  factory :counting do
    users { 1 }
    quiz_play { 2 }
    article_views { 3 }
    communities { 4 }
    talks { 5 }
  end
end
