$('turbolinks:load', function(){
  // カテゴリーセレクトボックスのオプションを作成
  function appendOption(genre){
    var html = `<option value="${genre.id}" data-genre="${genre.id}">${genre.name}</option>`;
    return html;
  }
  // 子カテゴリーの表示作成
  function appendChidrenBox(insertHTML){
    var childSelectHtml = '';
    childSelectHtml = `<div class='listing-select-wrapper__added' id= 'children_wrapper'>
                        <div class='listing-select-wrapper__box'>
                          <select class="listing-select-wrapper__box--select" id="child_genre" name="post[genre_id]">
                            <option value="---" data-genre="---">---</option>
                            ${insertHTML}
                          </select>
                        </div>
                      </div>`;
    $('.listing-post-detail__genre').append(childSelectHtml);
  }

  //　親カテゴリー選択後のイベント
  $('#parent_genre').on('change', function(){
    console.log('親カテゴリー選択')
    var parentGenre = document.getElementById('parent_genre').value; //選択された親カテゴリーの名前を取得
    if (parentGenre != "---"){ //親カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/posts/get_genre_children',
        type: 'GET',
        data: { parent_name: parentGenre },
        dataType: 'json'
      })
      .done(function(children){
        $('#children_wrapper').remove(); //親が変更された時、子以下を削除する
        var insertHTML = '';
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChidrenBox(insertHTML);
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#children_wrapper').remove(); //親カテゴリーが初期値になった時、子以下を削除する
    }
  });
});


//admins 投稿編集
$('turbolinks:load', function(){
  // カテゴリーセレクトボックスのオプションを作成
  function appendOption(genre){
    var html = `<option value="${genre.id}" data-genre="${genre.id}">${genre.name}</option>`;
    return html;
  }
  // 子カテゴリーの表示作成
  function appendChidrenBox(insertHTML){
    var childSelectHtml = '';
    childSelectHtml = `<div class='listing-select-wrapper__added' id= 'children_wrapper'>
                        <div class='listing-select-wrapper__box'>
                          <select class="listing-select-wrapper__box--select" id="child_genre" name="post[genre_id]">
                            <option value="---" data-genre="---">---</option>
                            ${insertHTML}
                          </select>
                        </div>
                      </div>`;
    $('.listing-post-detail__genre').append(childSelectHtml);
  }

  //　親カテゴリー選択後のイベント
  $('#admins_parent_genre').on('change', function(){
    console.log('xxx')
    var parentGenre = document.getElementById('admins_parent_genre').value; //選択された親カテゴリーの名前を取得
    if (parentGenre != "---"){ //親カテゴリーが初期値でないことを確認
      $.ajax({
        url: '/admins/posts/genre_children',
        type: 'GET',
        data: { parent_name: parentGenre },
        dataType: 'json'
      })
      .done(function(children){
        $('#children_wrapper').remove(); //親が変更された時、子以下を削除する
        var insertHTML = '';
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChidrenBox(insertHTML);
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#children_wrapper').remove(); //親カテゴリーが初期値になった時、子以下を削除する
    }
  });
});