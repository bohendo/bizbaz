# Instructions to install

## Installation instructions

%bizbaz depends on %pals to propagate adverts so you must install %pals first (/1/desk/~paldev/pals). You can add ~dibmet-narren & ~talsyx-talsud as pals to get some existing adverts.

Once you have some pals, install by running `|install ~dibmet-narren %bizbaz` or searching for apps by ~dibmet-narren from the landscape app.

App link: /1/desk/~dibmet-narren/bizbaz

To use bizbaz on a fake ~zod ship, see the local installation section of the project's readme:
https://github.com/bohendo/bizbaz#local-installation

# Usage Instructions

Note that you'll need to install bizbaz on at least 2 ships that are mutual pals to test out all of the features. For brevity, we'll refer to these two ships as ~zod and ~nec while describing usage.

If you have pals who have published adverts and you don't see them on the home page, click the refresh button in the top right. This is not normally necessary, but might help get your ship unstuck if an error has occurred.

From ~zod:
- create three adverts with titles like "good advert", "bad advert", and "ugly advert" by clicking the "+" button in the bottom right corner and submitting the advert creation form. Adverts are displayed as markdown, so you can add formatting or links to images, videos, and even 3D models in `glb` format!
- click the good advert card and make it even better by hovering over the button in the bottom right and clicking "Edit"
- return to the home page by clicking the home icon in the top left
- open the ugly advert and delete it by hovering over the button in the bottom right and clicking "Delete".

From ~nec:
- the home page should display the (updated) good advert and the bad advert created by ~zod.
- open the bad advert and upvote it by clicking the up arrow, unvote by clicking the up arrow again, and downvote by clicking the down arrow. Note that after downvoting, it's deleted from ~nec but is still present on ~zod (with a score of -1)
- return home and click the good advert card.
- click "Message Vendor" to open the talk app and send a message to ~zod asking for more details.
- click "Express Intent" on the good advert page to move forward with the transaction.

From ~zod:
- open the talk app to respond to the message from ~nec then click "Commit" on the good advert's intent card once you're ready.
- at this point, both parties would uphold their end of the agreed upon transaction
- click "Review" on the commit card and thank ~nec for being such a great client.

From ~nec:
- click "Review" on the good advert's commit card and chastise ~zod for being a bad vendor.
- check out ~zod's review, feel guilty, click the "pencil" icon on ~nec's review and update your review of ~zod to be slightly nicer.
- click ~zod's name in the review or advert details to explore ~zod's profile including all of ~zod's adverts, reviews of ~zod, and reviews by ~zod.
- click an advert hash in one of the reviews on ~zod's profile to view that advert page.

For more information, see the usage section of the project's readme:
https://github.com/bohendo/bizbaz#usage
