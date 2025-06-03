async function loadData() {
  const res = await fetch('./size-history.json');
  const data = await res.json();

  const table = document.createElement('table');
  table.innerHTML = `
    <thead>
      <tr>
        <th>Date</th>
        <th>Commit</th>
        <th>Message</th>
        <th>Committer</th>
        <th>Size (MB)</th>
        <th>Δ Size</th>
        <th>Release</th>
      </tr>
    </thead>
    <tbody>
      ${data
        .map(
          (entry) => `
        <tr>
          <td>${entry.date}</td>
          <td><code>${entry.commit.slice(0, 7)}</code></td>
          <td>${entry.commitMessage}</td>
          <td>${entry.committer}</td>
          <td>${(entry.size / 1024 / 1024).toFixed(2)} MB</td>
          <td style="color: ${
            entry.sizeDiff > 0 ? 'red' : entry.sizeDiff < 0 ? 'green' : 'gray'
          }">${(entry.sizeDiff / 1024).toFixed(1)} KB</td>
          <td>${entry.isRelease ? `✅ ${entry.tag || ''}` : '—'}</td>
        </tr>
      `
        )
        .join('')}
    </tbody>
  `;

  const container = document.getElementById('size-table');
  container.innerHTML = '';
  container.appendChild(table);
}

loadData();
