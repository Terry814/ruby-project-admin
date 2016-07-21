appstore_categories = {
  books: "Books",
  business: "Business",
  catalogs: "Catalogs",
  education: "Education",
  entertainment: "Entertainment",
  finance: "Finance",
  food_n_drink: "Food & Drink",
  health_n_fitness: "Health & Fitness",
  lifestyle: "Lifestyle",
  medical: "Medical",
  music: "Music",
  navigation: "Navigation",
  news: "News",
  photo_n_video: "Photo & Video",
  productiviy: "Productivity",
  reference: "Reference",
  social: "Social Networking",
  sports: "Sports",
  travel: "Travel",
  utilities: "Utilities",
  weather: "Weather",
}
play_market_categories = {
  books_n_reference: "Books & Reference",
  business: "Business",
  comics: "Comics",
  communication: "Communication",
  education: "Education",
  entertainment: "Entertainment",
  finance: "Finance",
  health_n_fitness: "Health & Fitness",
  libraries_n_demo: "Libraries & Demo",
  lifestyle: "Lifestyle",
  media_n_video: "Media & Video",
  medical: "Medical",
  music_n_audio: "Music & Audio",
  news_n_magazines: "News & Magazines",
  personalization: "Personalization",
  photography: "Photography",
  productivity: "Productivity",
  shopping: "Shopping",
  social: "Social",
  sports: "Sports",
  tools: "Tools",
  transportation: "Transportation",
  travel_n_local: "Travel & Local",
  weather: "Weather"
}

cats = OpenStruct.new(
  appstore: appstore_categories, 
  play_market: play_market_categories
  )

Rails.configuration.stores_categories = cats