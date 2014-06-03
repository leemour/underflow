json.selector class_with_id(@question)
json.favored  !!@favored
json.text @favored ? t('favorite.favored') : t('favorite.favor')