
var SortableUtils = {

  debug: function() {
    for (var key in Sortable.sortables) {
      console.group('Sortable.sortables[',key,']');
      console.log("Containment: %o",Sortable.sortables[key].containment);
      console.log("Draggables:  %o",Sortable.sortables[key].draggables);
      console.log("Droppables:  %o",Sortable.sortables[key].droppables);
      console.log("LastValue:   %o",this.getDragObserver(Sortable.sortables[key].element).lastValue);
      console.groupEnd()
    };
  },

  dropDebug: function() {
    Droppables.drops.each(function(drop,index){
      console.group('Droppables.drops[',index,']');
      console.dir(drop);
      console.groupEnd()
    });
  },

  dragDebug: function() {
    Draggables.drags.each(function(drag,index){
      console.group('Draggables.drags[',index,']');
      console.log("element:   %o",drag.element);
      console.log("handle:    %o",drag.handle);
      console.log("options:   %o",drag.options);
      console.log("dragging:  %o",drag.dragging);
      console.groupEnd()
    });
    Draggables.observers.each(function(ob,index){
      console.group('Draggables.observers[',index,']');
      console.log("element:   %o",ob.element);
      console.log("lastValue: %o",ob.lastValue);
      console.groupEnd()
    });
  },

  getDragObserver: function(element) {
    return Draggables.observers.find(function(d){ return d.element == element });
  },

  getOldNewSort: function(element) {
    var dragObserver = SortableUtils.getDragObserver(element);
    var oldSort = dragObserver.lastValue.toQueryParams()[element.id+'[]'];
    if (oldSort == undefined) { var oldSort = $A(); };
    if (!(oldSort instanceof Array)) { var oldSort = $A([oldSort]); };
    var newSort = Sortable.sequence(element.id);
    return {old:oldSort,now:newSort};
  },

  getSortParams: function(sortable) {
    var sort = Try.these(
      function() { return SortableUtils.getOldNewSort(sortable.sortableList()); },
      function() { return SortableUtils.getOldNewSort(sortable.sortableElement()); }
    );
    // Find the change within the sortable
    if (sort.old.length == sort.now.length) {
      sort.old.each(function(id,index) {
        if (id != sort.now[index]) {
          /* Check to see if the draggable was moved down */
          if (sort.old[index+1] == sort.now[index]) { drag_id = id; drag_position = sort.now.indexOf(id)+1; };
          /* Check to see if the draggable was moved up */
          if (sort.old[index] == sort.now[index+1]) { drag_id = sort.now[index]; drag_position = index+1; };
          throw $break;
        };
      });
      var params = { id:drag_id, position:drag_position, internal_sort:true };
    }
    // Find the new or lost draggable
    else {
      /* A lost draggable is ignored by the server */
      if (sort.old.length > sort.now.length) {
        var params = { lost_sortable:true };
      }
      /* Find the first new draggable id and position, it will be one gained */
      else {
        sort.now.each(function(id,index) {
          if (id != sort.old[index]) { drag_id = id; drag_position = index+1; throw $break; };
        });
        var params = { id:drag_id, position:drag_position, gained_id:sortable.id };
      };
    };
    return $H(params);
  },

  createSortableMember: function(sortable,member) {
    SortableUtils.createDraggableForSortable(sortable,member);
    SortableUtils.createDroppableForSortable(sortable,member);
    SortableUtils.resetSortableLastValue(sortable);
    SortableUtils.updateContainment(member);
  },

  createDraggableForSortable: function(sortable,member) {
    var options = Sortable.sortables[sortable.id];
    var options_for_draggable = {
      revert:             true,
      quiet:              options.quiet,
      scroll:             options.scroll,
      scrollSpeed:        options.scrollSpeed,
      scrollSensitivity:  options.scrollSensitivity,
      delay:              options.delay,
      ghosting:           options.ghosting,
      constraint:         options.constraint,
      handle:             member.down('.'+options.handle) };
    options.draggables.push(
      new Draggable(member,options_for_draggable)
    );
  },

  createDroppableForSortable: function(sortable,member) {
    var options = Sortable.sortables[sortable.id];
    var options_for_droppable = {
      overlap:     options.overlap,
      containment: options.containment,
      tree:        options.tree,
      hoverclass:  options.hoverclass,
      onHover:     Sortable.onHover }
    Droppables.add(member,options_for_droppable);
    options.droppables.push(member);
  },

  resetSortableLastValue: function(element) {
    SortableUtils.getDragObserver(element).onStart();
  },

  updateSortablesDragAndDrops: function(element) {
    if (Page.gainedSortable == element) {
      var thisSortable = Sortable.sortables[element.id];
      var oldSortable = $H(Sortable.sortables).detect(function(kv){ return $A(kv[1].droppables).include(Page.draggedElement); }).last();
      var dragObj = $A(oldSortable.draggables).detect(function(drag){ return Page.draggedElement == drag.element; });
      /* Remove draggedElement and dragObj from oldSortable */
      oldSortable.droppables = oldSortable.droppables.without(Page.draggedElement);
      oldSortable.draggables = oldSortable.draggables.without(dragObj);
      /* Adding draggedElement and dragObj to thisSortable */
      thisSortable.droppables.push(Page.draggedElement);
      thisSortable.draggables.push(dragObj);
    };
  },

  sortablesArray: function() {
    var results = [];
    for (var property in Sortable.sortables) {
      var value = Sortable.sortables[property];
      results.push(value);
    };
    return results;
  },

  updateContainment: function(newMember) {
    var classes = $w(newMember.className);
    var newColumn = classes.include('dragable_columns');
    var newBox = classes.include('dragable_boxes');
    if (!newColumn && !newBox) { return false };
    if (newColumn) {
      var accept = 'dragable_boxes';
      var containment = Box.containment();
      var firstDrop = (Columns.size() == 0) ? null : Columns[0].column;
    }
    else {
      var accept = 'dragable_bmarks';
      var containment = Bookmark.containment();
      var firstDrop = Inbox.sortableList();
    };
    SortableUtils.sortablesArray().each(function(sortable){
      if (sortable.accept == accept) { sortable.containment = containment; };
    });
    Droppables.drops.each(function(drop){
      if (drop.containment && drop.containment.include(firstDrop)) {
        drop._containers = containment;
        drop.containment = containment;
      };
    });
  },

  destroySortableMember: function(parent,member) {
    /* Cherry pick from Sortable.destroy to accomodate only a droppable of the sortable. */
    var sortable = Sortable.sortables[parent.id];
    /* Killing droppables and refs. */
    sortable.droppables = sortable.droppables.without(member);
    Droppables.remove(member);
    /* Killing draggables and refs. */
    var draggable = sortable.draggables.find(function(d){ return d.element == member });
    draggable.destroy();
    sortable.draggables = sortable.draggables.without(draggable);
    /* Make sure to kill the Draggables.observer */
    var dragObserver = Draggables.observers.find(function(o){ return o.element == member });
    Draggables.observers = Draggables.observers.without(dragObserver);
    /* Now remove the Sortable key */
    delete Sortable.sortables[member.id];
  },

  destroySortableSubparent: function(subparent) {
    /* Cherry pick from Sortable.destroy to accomodate an empty bookmark sortable parent. */
    var sortable = Sortable.sortables[subparent.id];
    /* Killing droppables and refs. */
    sortable.droppables = sortable.droppables.without(subparent);
    Droppables.remove(subparent);
    /* Make sure to kill the Draggables.observer */
    var dragObserver = Draggables.observers.find(function(o){ return o.element == subparent });
    Draggables.observers = Draggables.observers.without(dragObserver);
    /* Now remove the Sortable key */
    delete Sortable.sortables[subparent.id];
  },

  destroySortableMemberPostDOM: function(parent,member) {
    SortableUtils.updateContainment(member);
    SortableUtils.resetSortableLastValue(parent);
  }

};

