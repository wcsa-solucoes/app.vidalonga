//routes
const routes = (
  app: (
    path: "/app",
    auth: (
      path: "/app/auth/",
      login: (path: "/app/auth/"),
    ),
    home: (
      path: "/app/home/",
      article: (
        path: "/app/home/article",
        comments: (path: "/app/home/article/comments"),
      ),
    ),
    profile: (
      path: "/app/profile/",
      edit: (path: "/app/profile/edit"),
      subscriptions: (path: "/app/profile/subscriptions",),
      qrcode: (path: "/app/profile/qrcode"),
      favorites: (path: "/app/profile/favorites"),
    ),
    categories: (
      path: "/app/categories/",
      subCategories: (
        path: "/app/categories/subCategories",
        articles: (path: "/app/categories/subCategories/articles"),
      ),
    ),
    qa: (
      path: "/app/questionsAndAnswers/",
      question: (path: "/app/questionsAndAnswers/question"),
      newQuestion: (path: "/app/questionsAndAnswers/newQuestion"),
    ),
    partners: (
      path: "/app/partners/",
      benefitDetails: (path: "/app/partners/benefitDetails"),
    )
  )
);
