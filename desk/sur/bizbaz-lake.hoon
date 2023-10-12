/-  advert, report, review
=<  ::  SSS lake
|%
++  name  %bizbaz
+$  rock  $:  adverts=(list advert:advert)          ::   state to be shared
              reports=(list report:report)
              reviews=(list review:review)
              commits=(list commit:review:review)
           ==
+$  wave  $%  [%create-advert advert=advert:advert]  ::  update to the state
              [%update-advert advert=advert:advert]
              [%delete-advert hash=@uvH]
              ::
              [%create-report report=report:report]     
              [%update-report report=report:report]  
              [%delete-report hash=@uvH]
              ::
              [%create-review review=review:review]     
              [%update-review review=review:review]  
              [%delete-review hash=@uvH]
              ::
              [%create-commit commit=commit:review:review]     
              [%update-commit commit=commit:review:review]  
              [%delete-commit hash=@uvH]
          ==
++  wash
  |=  [=rock =wave]
  ?-    -.wave
    ::
    ::
      %create-advert
    rock(adverts [[advert.wave] adverts.rock])
    ::
      %update-advert
    rock(adverts ;;((list advert:advert) (murn adverts.rock |=(old=item ?:(=(-:old -:advert.wave) advert.wave `old)))))
    ::
      %delete-advert
    rock(adverts ;;((list advert:advert) (delete-by-hash adverts.rock hash.wave)))
    ::
    ::
      %create-report
    rock(reports [[report.wave] reports.rock])
    ::
      %update-report
    rock(reports ;;((list report:report) (update-by-hash reports.rock report.wave)))
    ::
      %delete-report
    rock(reports ;;((list report:report) (delete-by-hash reports.rock hash.wave)))
    ::
    ::
      %create-review
    rock(reviews [[review.wave] reviews.rock])
    ::
     %update-review
    rock(reviews ;;((list review:review) (update-by-hash reviews.rock review.wave)))
    ::
      %delete-review
    rock(reviews ;;((list review:review) (delete-by-hash reviews.rock hash.wave)))
    ::
    ::
      %create-commit
    rock(commits [[commit.wave] commits.rock])
    ::
      %update-commit
    rock(commits ;;((list commit:commit:review) (update-by-hash commits.rock commit.wave)))
    ::
      %delete-commit
    rock(commits ;;((list commit:commit:review) (delete-by-hash commits.rock hash.wave)))
    ::
  ==
--
|%
++  delete-by-hash
  |=  [lis=(list item) hash=@uvH]
  (skip lis |=(a=item =(-:a hash)))
::
++  update-by-hash
  |=  [lis=(list item) new=item]
  (murn lis |=(old=item ?:(=(-:old -:new) `new `old)))
::
+$  item  $%  advert:advert
              report:report
              review:review 
              commit:commit:review:review
          ==
--


