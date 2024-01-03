//routes
const routes = (
  app: (
    path: "/app",
    auth: (
      path: "/app/auth",
      login: (path: "/app/auth/login"),
    ),
    navigation: (path: "/navigation"),
    home: (
      path: "/app/home",
      article: (
        path: "/app/home/article",
        comments: (path: "/app/home/article/comments"),
      ),
    ),
    profile: (path: "/app/profile", edit: (path: "/app/profile/edit")),
    categories: (
      path: "/app/categories",
      subCategories: (
        path: "/app/categories/subCategories",
        articles: (path: "/app/categories/subCategories/articles"),
      ),
    ),
  )
);
