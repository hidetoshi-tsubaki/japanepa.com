$(function () {
  $('[data-provider="summernote"]').each(function () {
    $(this).summernote({
      lang: 'ja-JP',
      height: 550,
      fontNames: ['Helvetica', 'sans-serif', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
      fontNamesIgnoreCheck: ['Helvetica', 'sans-serif', 'Arial', 'Arial Black', 'Comic Sans MS', 'Courier New'],
      toolbar: [
        ['style', ['bold', 'italic', 'underline', 'clear']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['font', ['strikethrough']],
        ['para', ['ul', 'ol','paragraph']],
        ['height', ['height']]
        ['table', ['table']],
        ['insert', ['link', 'picture', 'video', 'hr']],
        ['view', ['fullscreen', 'codeview', 'help']],
      ],
      callbacks: {
        onImageUpload: function (files, editor, welEditable) {
          sendFile(files[0], editor, welEditable);
        },
        onMediaDelete: function (image) { 
          var image_url = image[0].src;
          deleteFile(image_url);
        
        }
      },
      popover: {
        image: [
          ['image', ['resizeFull', 'resizeHalf', 'resizeQuarter', 'resizeNone']],
          ['float', ['floatLeft', 'floatRight', 'floatNone']],
          ['remove', ['removeMedia']]
        ],
        link: [
          ['link', ['linkDialogShow', 'unlink']]
        ],
        table: [
          ['add', ['addRowDown', 'addRowUp', 'addColLeft', 'addColRight']],
          ['delete', ['deleteRow', 'deleteCol', 'deleteTable']],
        ],
        air: [
          ['color', ['color']],
          ['font', ['bold', 'underline', 'clear']],
          ['para', ['ul', 'paragraph']],
          ['table', ['table']],
          ['insert', ['link', 'picture']]
        ]
      }
    });
  })

  function sendFile(file, editor, welEditable) {
    data = new FormData();
    data.append('upload_image', file);
    $.ajax({
      url: '/articles/image_upload',
      data: data,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      success: function (data) {
        $('[data-provider="summernote"]').summernote('insertImage', data.url);
      },
      error: function () {
        alert('failed to upload the image.Try again');
      }
    });
  }

  function deleteFile(image_url){
    data = new FormData();
    data.append('image_url',image_url);
    $.ajax({
      url:'/articles/delete_image',
      data:data,
      cache: false,
      contentType: false,
      processData: false,
      type: 'POST',
      success:function(){
        console.log('deleted inserted image successfully');
      },
      error: function(){
        alert('failed to delete the inserted image ... ');
      }
    })
  }
  $(function () {
    $('#article-tags').tagit({
      fieldName: 'article[tag_list]',
      singleField: true,
      availableTags: gon.available_tags
    });
  })
  if(gon.article_tags){
    for (var i = 0; i < gon.article_tags.length; i++){
      $('#article-tags').tagit(
        'createTag', gon.article_tags[i]
      )
    }
  }
})
