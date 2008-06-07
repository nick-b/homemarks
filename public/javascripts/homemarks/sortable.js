
var SortableUtils = {
  
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
  },
  
  resetSortableLastValue: function(element) {
    SortableUtils.getDragObserver(element).onStart()
  }
  
};

