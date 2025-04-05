//  5秒ごとにリロード、下のコードを適応したいビューに置く
//  <%= javascript_pack_tag 'autoreload' %>

const interval = setInterval('location.reload()', 5000)
$(document).on('turbolinks:before-cache turbolinks:before-render', () => clearTimeout(interval))