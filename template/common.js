function checkIframeAccess() {
	if (window === window.top) {
		const currentPage = window.location.pathname.split('/').pop();
		let redirectUrl = 'index.html';
		
		switch(currentPage) {
			case 'usage.html':
				redirectUrl = 'index.html#usage';
				break;
			case 'disclaimer.html':
				redirectUrl = 'index.html#disclaimer';
				break;
			case 'top.html':
			default:
				redirectUrl = 'index.html#top';
				break;
		}
		
		window.location.href = redirectUrl;
	}
}

document.addEventListener('DOMContentLoaded', function() {
	checkIframeAccess();
});
