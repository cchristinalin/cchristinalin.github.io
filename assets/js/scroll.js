// Smooth scroll for anchor links with offset for sticky nav
(function(){
  function offsetScroll(target) {
    var nav = document.querySelector('.top-nav');
    var navHeight = nav ? nav.getBoundingClientRect().height : 72;
    var rect = target.getBoundingClientRect();
    var absoluteY = window.pageYOffset + rect.top;
    var targetY = Math.max(absoluteY - navHeight - 12, 0);
    window.scrollTo({ top: targetY, behavior: 'smooth' });
  }

  document.addEventListener('click', function(e){
    var link = e.target.closest('a');
    if(!link) return;
    var href = link.getAttribute('href');
    if(!href) return;
    if(href.startsWith('#')){
      var id = href.slice(1);
      var el = document.getElementById(id);
      if(el){
        e.preventDefault();
        offsetScroll(el);
        history.pushState(null, '', href);
      }
    }
  }, {passive:false});
})();
