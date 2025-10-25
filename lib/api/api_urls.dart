class ApiUrls {
  // API User
  final Uri API_GET_USER = Uri.parse('https://api.randomuser.me/?results=50');

  // API Auth
  final Uri API_LOGIN = Uri.parse('http://0.0.0.0:5046/moifood/auth/login');
  final Uri API_REGISTER = Uri.parse('http://0.0.0.0:5046/moifood/auth/register');
  final Uri API_LOGOUT = Uri.parse('http://0.0.0.0:5046/moifood/auth/logout');
  final Uri API_FORGOT_PASSWORD = Uri.parse('http://0.0.0.0:5046/moifood/auth/forgot-password');
  final Uri API_VERIFY_OTP = Uri.parse('http://0.0.0.0:5046/moifood/auth/verify-otp');
  final Uri API_RESEND_OTP = Uri.parse('http://0.0.0.0:5046/moifood/auth/resend-otp');
  final Uri API_RESET_PASSWORD = Uri.parse('http://0.0.0.0:5046/moifood/auth/reset-password');
  
  // Profile
  final Uri API_GET_PROFILE = Uri.parse('http://0.0.0.0:5046/moifood/profile');
  final Uri API_UPDATE_PROFILE = Uri.parse('http://0.0.0.0:5046/moifood/profile/update-profile');
  final Uri API_CHANGE_PASSWORD = Uri.parse('http://0.0.0.0:5046/moifood/profile/change-password');
  final Uri API_UPLOAD_AVATAR = Uri.parse('http://0.0.0.0:5046/moifood/profile/upload-avatar');

  // API Category
  final Uri API_CATEGORY_MODIFY = Uri.parse('http://0.0.0.0:5046/moifood/category/modify');
  final Uri API_CATEGORY_DELETE = Uri.parse('http://0.0.0.0:5046/moifood/category/delete-Category');
  final Uri API_CATEGORY_GET_ALL = Uri.parse('http://0.0.0.0:5046/moifood/category/get-all');
  final Uri API_CATEGORY_GET_BY_ID = Uri.parse('http://0.0.0.0:5046/moifood/category/getById');
  final Uri API_CATEGORY_RESTORE = Uri.parse('http://0.0.0.0:5046/moifood/category/restore-Category');

  // API Food
  final Uri API_FOOD_MODIFY = Uri.parse('http://0.0.0.0:5046/moifood/food/modify');
  final Uri API_FOOD_GET_ALL = Uri.parse('http://0.0.0.0:5046/moifood/food/get-all');
  final Uri API_FOOD_SET_ACTIVE_STATUS = Uri.parse('http://0.0.0.0:5046/moifood/food/set-active-status');
  final Uri API_FOOD_SET_AVAILABLE_STATUS = Uri.parse('http://0.0.0.0:5046/moifood/food/set-available-status');
  final Uri API_FOOD_DELETE = Uri.parse('http://0.0.0.0:5046/moifood/food/delete');

  // API Cart
  final Uri API_GET_CART = Uri.parse("http://0.0.0.0:5046/moifood/cart/");
  final Uri API_ADD_TO_CART = Uri.parse("http://0.0.0.0:5046/moifood/cart/add-to-cart");
  final Uri API_UPDATE_QUANTITY = Uri.parse("http://0.0.0.0:5046/moifood/cart/update-quantity");
  final Uri API_REMOVE_FROM_CART = Uri.parse("http://0.0.0.0:5046/moifood/cart/remove-from-cart");

  // API Order
  final Uri API_GET_ORDERS = Uri.parse("http://0.0.0.0:5046/moifood/order/get-orders");
  final Uri API_GET_ORDER_DETAILS = Uri.parse("http://0.0.0.0:5046/moifood/order/get-order-details");
  final Uri API_CREATE_ORDER = Uri.parse("http://0.0.0.0:5046/moifood/order/create-order");
  final Uri API_GET_ALL_ORDERS = Uri.parse("http://0.0.0.0:5046/moifood/order/get-all-order");
  final Uri API_GET_ORDER_BY_ID = Uri.parse("http://0.0.0.0:5046/moifood/order/get-order-by-id");
  final Uri API_UPDATE_ORDER_STATUS = Uri.parse("http://0.0.0.0:5046/moifood/order/update-order-status");

  // API Payment
  final Uri API_PAYMENT_PROCESS = Uri.parse("http://0.0.0.0:5046/moifood/payment/process");
  final Uri API_GET_PAYMENT_METHODS = Uri.parse("http://0.0.0.0:5046/moifood/payment/get-payment-methods");
  final Uri API_PAYMENT_MODIFY = Uri.parse("http://0.0.0.0:5046/moifood/payment/modify-payment-method");
  final Uri API_PAYMENT_MOMO_IPN = Uri.parse("http://0.0.0.0:5046/moifood/payment/momo-ipn");
  final Uri API_PAYMENT_ORDER = Uri.parse("http://0.0.0.0:5046/moifood/payment/order/");

  // Reviews
  final Uri API_REVIEW_MODIFY = Uri.parse("http://0.0.0.0:5046/moifood/review/modify");
  final Uri API_REVIEW_GET_HISTORY_BY_USER = Uri.parse("http://0.0.0.0:5046/moifood/review/get-history-by-user");
  final Uri API_REVIEW_DELETE = Uri.parse("http://0.0.0.0:5046/moifood/review/delete-review");
  final Uri API_REVIEW_GET_ALL = Uri.parse("http://0.0.0.0:5046/moifood/review/get-all-review");
  final Uri API_REVIEW_GET_BY_FOOD_USER = Uri.parse("http://0.0.0.0:5046/moifood/review/get-review-by-food-user");
  final Uri API_REVIEW_DELETE_BY_ADMIN = Uri.parse("http://0.0.0.0:5046/moifood/review/delete-by-admin");
  final Uri API_REVIEW_FILTER = Uri.parse("http://0.0.0.0:5046/moifood/review/filter-reviews");

  // API Notification 

  // API Statistics
}
