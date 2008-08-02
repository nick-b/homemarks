


/*  Custom sortable serialize params Bookmark#sort
 * ----------------------------------------------------------------------------------------------------------------- */

function findDroppedBookmarkInfo(obj) {
  sortable_id = obj.element.id;
  sortable_id_num = sortable_id.gsub(/boxid_list_/i,'');
  box_type = findSortableBoxType(sortable_id_num);
  box_empty = obj.lastValue.length == 0 ? true : false ;
  lastvalues = $A(obj.lastValue.gsub(/(boxid_list_\d+|inbox_list|trashbox_list)\[\]=/i,'').split('&'));
  sortable_seq = $A(Sortable.sequence(sortable_id));
  if ((lastvalues.length == sortable_seq.length) && !box_empty) { // Find the bookmark info within the sortable.
    internal_sort = true; lost_bmark = false; bmark_scope = box_type;
    lastvalues.each(function(v,i) {
      if (v != sortable_seq[i]) {
        /* Check to see if the bookmark was moved down */
        if (lastvalues[i+1] == sortable_seq[i]) { bmark_id=v; bmark_position=sortable_seq.indexOf(v)+1; };
        /* Check to see if the bookmark was moved up */
        if (lastvalues[i] == sortable_seq[i+1]) { bmark_id=sortable_seq[i]; bmark_position=i+1; };
        throw $break;
      };
    });
  }
  else { // Find the new or lost bookmark info.
    internal_sort = false;
    lost_bmark = lastvalues.length > sortable_seq.length ? true : false ;
    /* Box's with a lost bookmark are ignored by the server. */
    if (lost_bmark == true) { bmark_id = 'na' ; bmark_position = 'na' ; bmark_scope = 'na'; }
    /* Box with no bookmarks now gaining one. */
    else if (box_empty) { bmark_id = sortable_seq[0] ; bmark_position = 1 ; bmark_scope = findBmarkScope(box_type,sortable_id); }
    else {
      long_array =  lastvalues.length > sortable_seq.length ? lastvalues : sortable_seq ;
      short_array =  lastvalues.length < sortable_seq.length ? lastvalues : sortable_seq ;
      long_array.each(function(v,i) {
        if (v != short_array[i]) { bmark_id=v; bmark_position=i+1; throw $break; };
      });
      bmark_scope = findBmarkScope(box_type,sortable_id);
    }
  }
  return 'internal_sort='+internal_sort+'&lost_bmark='+lost_bmark+'&box_type='+box_type+'&sortable_id='+sortable_id_num+'&bmark_id='+bmark_id+'&bmark_position='+bmark_position+'&bmark_scope='+bmark_scope
}


function findSortableBoxType(sortable_id_num) {
  if (sortable_id_num == 'inbox_list') { return 'inbox'; }
  else if (sortable_id_num == 'trashbox_list') { return 'trashbox'; }
  else { return 'box'; }
}

function findBmarkScope(box_type, sortable_id) {
  if (box_type == 'box') {
    if ($('inbox_list').visible() && sortableHasClass(sortable_id,'inbox')) {return 'inbox'}
    else if ($('trashbox_list').visible() && sortableHasClass(sortable_id,'trashbox')) {return 'trashbox'}
  }
  return 'box';
}

function sortableHasClass(sortable_id, css_class) {
  css_check = false
  $A($(sortable_id).childNodes).each(function(li) {
    if (li.hasClassName(css_class)) {css_check=true; throw $break;}
  });
  return css_check;
}




/*  Action Area Specific Functions
 * ----------------------------------------------------------------------------------------------------------------- */


function forceTrashbox(action_box) {
  if ((getFieldsetFlag()!='legend_trash') && (action_box=='trashbox')) { return true; } else { return false };
}

function forceTrashboxLoad() {
  loadingActionArea($('legend_trash_link'));
  new Ajax.Request('/actionarea/trashbox', {asynchronous:true, evalScripts:true});
}

function trashboxLoad() {
  setFieldsetFlag('legend_trash');
  $('legend_trash').classNames().set('fld_on');
  new Ajax.Request('/actionarea/trashbox', {asynchronous:true, evalScripts:true});
}

function inboxLoad() {
  setFieldsetFlag('legend_inbox');
  $('legend_inbox').classNames().set('fld_on');
  new Ajax.Request('/actionarea/inbox', {asynchronous:true, evalScripts:true});
}

function setFieldsetFlag(ulid) {
  $('fieldset_legend').classNames().set(ulid);
}

function getFieldsetFlag() {
  return $('fieldset_legend').classNames().toString();
}

function isActionAreaDisplayed(obj) {
  if (obj.childNodes[0].hasClassName('fld_on')) return false ;
  return true;
}

function loadingActionArea(obj) {
  clicked = obj.childNodes[0];
  currentFieldsetFlag = getFieldsetFlag();
  switch (currentFieldsetFlag) { 
    case 'legend_inbox' : hidelist = 'inbox_list' ; break;
    case 'legend_trash' : hidelist = 'trashbox_list' ; break;
  }
  setFieldsetFlag(clicked.id);
  clicked.classNames().set('fld_on');
  $(currentFieldsetFlag).classNames().set('');
  if (clicked.id != 'legend_trash') {$('trashbox_emptytrash_box').hide()};
  $('fieldset_progress_wrap').visualEffect('blind_down',{duration: 0.35});
  $(hidelist).visualEffect('blind_up',{duration: 0.35});
}

function showOrHideEmptyTrashBox() {
  emptyTrashBox = $('trashbox_emptytrash_box');
  if ( (Element.hasClassName('trashcan','trash_full')) && (getFieldsetFlag()=='legend_trash') ) {emptyTrashBox.show();} else {emptyTrashBox.hide();};
}










