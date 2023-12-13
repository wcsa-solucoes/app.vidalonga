//routes
const routes = (
app:(
  path: "/app",
  auth:(
    path: "/app/auth"
  ),
  navigation:(
    path: "/navigation"
  ),
  home:(
    path: "/app/home",
    article:(
      path: "/app/home/article",
      comments:(
        path: "/app/home/article/comments"
      ),
    ),
  ),
  profile:(
    path: "/profile"
  ),)
);