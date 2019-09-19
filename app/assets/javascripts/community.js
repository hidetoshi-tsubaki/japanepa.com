$(function () {
  $(function () {
    $('#form_tags').tagit({
      fieldName: 'community[tag_list]',
      singleField: true,
      availableTags: gon.available_tags
    });
    if (gon.community_tags) {
      for (var i = 0; i < gon.community_tags.length; i++) {
        $('#form-tags').tagit(
          'createTag', gon.article_tags[i]
        )
      }
    }
  })
})
