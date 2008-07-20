
var SortableUtils = {
  
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
    var element = sortable.list || sortable.box || sortable.column || sortable.sortable;
    var sort = SortableUtils.getOldNewSort(element);
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
    var newBox = classes.include('draggable_boxes');
    if (!newColumn && !newBox) { return false };
    if (newColumn) {
      var accept = 'dragable_boxes';
      var containment = Box.containment();
      var firstDrop = Columns[0].column;
    } 
    else {
      var accept = 'draggable_boxes';
      var containment = Box.containment();
      var firstDrop = Columns[0].column;
    };
    SortableUtils.sortablesArray().each(function(sortable){ 
      if (sortable.accept == accept) { sortable.containment = containment; };
    });
    Droppables.drops.each(function(drop){
      if (drop.containment.include(firstDrop)) {
        drop._containers = containment;
        drop.containment = containment;
      };
    }); 
  },
  
  destroySortableMember: function(parent,member) {
    // Cherry pick from Sortable.destroy to accomodate only a droppable of the sortable.
    var sortable = Sortable.sortables[parent.id];
    // Killing droppables and refs.
    sortable.droppables = sortable.droppables.without(member);
    Droppables.remove(member);
    // Killing draggables and refs.
    var draggable = sortable.draggables.find(function(d){ return d.element == member });
    draggable.destroy();
    sortable.draggables = sortable.draggables.without(draggable);
  }
  
};

