
var SortableUtils = {
  
  // doomed = $('col_101');
  // var sortables = Sortable.sortables.findAll(function(sortable){ return sortable.containment.include(doomed) });
  // var sortables = Sortable.sortables.findAll(function(sortable){ return sortable.accept == 'draggable_boxes' });
  // sortables.each(function(sortable){
  //   sortable.containment = Box.containment();
  // });
  
  // doomed = $('col_101');
  // var drops = Droppables.drops.findAll(function(obj){ return obj.containment.include(doomed) });
  // var drops = Droppables.drops.findAll(function(drop){ return drop.containment.include(Columns[0].column) });
  // drops.each(function(drop){
  //   drop._containers = Box.containment();
  //   drop.containment = Box.containment();
  // });
  
  // Draggables.drags
  // (no containment that I could find)
  
  
  
  
  // dragObserver = SortableUtils.getDragObserver($('col_wrapper'))
  
  // >>> dragObserver.lastValue
  // "col_wrapper[]=88&col_wrapper[]=87"
  
  // MUST ADD ONE??? Draggables.add(element)
  // sortable = Sortable.sortables['col_wrapper']
  // >>> sortable.droppables
  // [div#col_wrapper, div#col_88.dragable_columns, div#col_87.dragable_columns]
  
  // >>> sortable.draggables
  // [Object element=div#col_88.dragable_columns, Object element=div#col_87.dragable_columns]
  
  getDragObserver: function(element) {
    return Draggables.observers.find(function(d){ return d.element == element });
  },
  
  getOldNewSort: function(element) {
    var dragObserver = SortableUtils.getDragObserver(element);
    var oldSort = dragObserver.lastValue.toQueryParams()[element.id+'[]'];
    var newSort = Sortable.sequence(element.id);
    return {old:oldSort,now:newSort};
  },
  
  getSortParams: function(element) {
    var sort = SortableUtils.getOldNewSort(element);
    // Doing the work to find which and where the droppable was moved to.
    if (sort.old.length == sort.now.length) { /* Find the change within the sortable */
      sort.old.each(function(id,index) {
        if (id != sort.now[index]) { 
          /* Check to see if the droppable was moved down */
          if (sort.old[index+1] == sort.now[index]) { drop_id = id; drop_position = sort.now.indexOf(id)+1; };
          /* Check to see if the droppable was moved up */
          if (sort.old[index] == sort.now[index+1]) { drop_id = sort.now[index]; drop_position = index+1; };
          throw $break;
        };
      });
      var params = { id:parseInt(drop_id), position:parseInt(drop_position) };
      return $H(params);
    }
    else { 
      return false; 
    }
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
    if (newMember.hasClassName('dragable_columns')) {
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
  
  // SortableUtils.updateContainment(Columns[3])
  // SortableUtils.sortablesArray().each(function(sortable){ if (sortable.accept == 'dragable_boxes') { console.log(sortable); console.log(sortable.containment); }; });
  
  // doomed = $('col_101');
  // var sortables = Sortable.sortables.findAll(function(sortable){ return sortable.containment.include(doomed) });
  // var sortables = Sortable.sortables.findAll(function(sortable){ return sortable.accept == 'draggable_boxes' });
  // sortables.each(function(sortable){
  //   sortable.containment = Box.containment();
  // });
  
  // doomed = $('col_101');
  // var drops = Droppables.drops.findAll(function(obj){ return obj.containment.include(doomed) });
  // var drops = Droppables.drops.findAll(function(drop){ return drop.containment.include(Columns[0].column) });
  // drops.each(function(drop){
  //   drop._containers = Box.containment();
  //   drop.containment = Box.containment();
  // });
  
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

