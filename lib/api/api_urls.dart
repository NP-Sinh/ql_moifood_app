class ApiUrls {
  static const String baseUrl = 'http://localhost:5046/moifood/';

  // Auth
  static final Uri login = Uri.parse('${baseUrl}auth/login');
  static final Uri logout = Uri.parse('${baseUrl}auth/logout');
  // Profile
  static final Uri getProfile = Uri.parse('${baseUrl}profile');
  // caterogy
  static final Uri modifyCategory = Uri.parse('${baseUrl}category/modify');
  static final Uri getAllCategory = Uri.parse('${baseUrl}category/get-all');
  static final Uri getDeletedCategory = Uri.parse('${baseUrl}category/get-deleted');
  static final Uri categoryGetById = Uri.parse('${baseUrl}category/getById');
  static final Uri deleteCategory = Uri.parse('${baseUrl}category/delete-Category');
  static final Uri restoreCategory = Uri.parse('${baseUrl}category/restore-Category');

  // food
   static final Uri foodGetAll = Uri.parse('${baseUrl}food/get-all');
  static final Uri foodGetByCategory = Uri.parse('${baseUrl}food/get-by-category');
  static final Uri foodModify = Uri.parse('${baseUrl}food/modify');
  static final Uri setActiveStatus = Uri.parse('${baseUrl}food/set-active-status');
  static final Uri setAvailableStatus = Uri.parse('${baseUrl}food/set-available-status');
  static final Uri deleteFood = Uri.parse('${baseUrl}food/delete');
  static final Uri searchFood = Uri.parse('${baseUrl}food/search');

  // order
  static final Uri getAllOrder = Uri.parse('${baseUrl}order/get-all-order');
  static final Uri getOrderById = Uri.parse('${baseUrl}order/get-order-by-id');
  static final Uri updateOrderStatus = Uri.parse('${baseUrl}order/update-order-status');

  // reviews
  static final Uri getAllReviews = Uri.parse('${baseUrl}review/get-all-reviews');
  static final Uri deleteByAdmin = Uri.parse('${baseUrl}review/delete-by-admin');
  static final Uri filterReviews = Uri.parse('${baseUrl}review/filter-reviews');

  // statistics
  static final Uri getRevenue = Uri.parse('${baseUrl}statistics/revenue');
  static final Uri getOrderCount = Uri.parse('${baseUrl}statistics/order-count');
  static final Uri getFoodOrderStats = Uri.parse('${baseUrl}statistics/food-orders');
  static final Uri getUserSpending = Uri.parse('${baseUrl}statistics/user-spending');

  // User
   static final Uri getAllUser = Uri.parse('${baseUrl}user/get-all-user');
  static final Uri getUserById = Uri.parse('${baseUrl}user/get-user-by-id');
  static final Uri searchUser = Uri.parse('${baseUrl}user/search-user');
  static final Uri setActiveUser = Uri.parse('${baseUrl}user/set-active-user');
}
