export function formatPrice(cents) {
  if (cents == null) return '—'
  return (cents / 100).toFixed(2)
}

export function formatDate(datetime) {
  if (!datetime) return '—'
  return datetime.substring(0, 10)
}

export function formatScore(score) {
  if (score == null) return '暂无'
  return (score / 10).toFixed(1)
}
